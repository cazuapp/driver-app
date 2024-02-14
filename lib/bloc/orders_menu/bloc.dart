/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023-2024, Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

import 'dart:async';
import 'package:cazuapp/core/defaults.dart';
import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/core/protocol.dart';

import 'package:cazuapp/models/order_list.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'event.dart';
part 'state.dart';

const _postLimit = AppDefaults.postLimit;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class OrdersMenuBloc extends Bloc<OrdersEvent, OrdersState> {
  AppInstance instance;

  OrdersMenuBloc({required this.instance}) : super(const OrdersState()) {
    /* Retrieves all orders from the past */

    on<OrdersFetch>(
      _onorderFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    on<Init>(_onInit);

    /* Invoked when scrolling down */

    on<OnHomeScroll>(_onHomeScroll);
    on<SetParam>(_onSetParam);
    on<SetText>(_onSetText);

    /* Sets date to retrieve orders from */

    on<SetDate>(_onSetDate);
  }

  Future<void> _onSetParam(
    SetParam event,
    Emitter<OrdersState> emit,
  ) async {
    final change = event.param;
    final text = event.text;

    emit(state.copyWith(param: change, text: text));
  }

  Future<void> _onSetDate(
    SetDate event,
    Emitter<OrdersState> emit,
  ) async {
    final changeEnd = event.dateEnd;
    final changeStart = event.dateStart;

    emit(state.copyWith(dateEnd: changeEnd, dateStart: changeStart));
  }

  Future<void> _onInit(
    Init event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(orders: const <OrderList>[], hasReachedMax: false));
  }

  Future<void> _onSetText(
    SetText event,
    Emitter<OrdersState> emit,
  ) async {
    final change = event.text;
    emit(state.copyWith(text: change));
  }

  Future<void> _onHomeScroll(
    OnHomeScroll event,
    Emitter<OrdersState> emit,
  ) async {
    await _onorderFetch(OrdersFetch(), emit);
  }

  Future<void> _onorderFetch(
    OrdersFetch event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      if (state.status == OrdersStatus.initial) {
        emit(state.copyWith(status: OrdersStatus.loading));

        final posts = await _fetchOrdersItems(emit: emit);

        posts.isEmpty
            ? emit(state.copyWith(status: OrdersStatus.success))
            : emit(
                state.copyWith(
                  status: OrdersStatus.success,
                  orders: posts,
                  hasReachedMax: false,
                ),
              );

        return;
      }

      final posts = await _fetchOrdersItems(emit: emit, startIndex: state.orders.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true, status: OrdersStatus.success))
          : emit(
              state.copyWith(
                status: OrdersStatus.success,
                orders: List.of(state.orders)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: OrdersStatus.failure));
    }
  }

  Future<List<OrderList>> _fetchOrdersItems({required Emitter<OrdersState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.orders.ordersMenu(
        offset: startIndex, limit: _postLimit, param: state.param, dateStart: state.dateStart, dateEnd: state.dateEnd);
    if (response?.model2 != null) {
      emit(state.copyWith(total: response?.model2));
    }
    if (response?.status == Protocol.empty) {
      return List<OrderList>.empty();
    }

    if (response?.model.isEmpty) {
      return List<OrderList>.empty();
    }

    return response?.model.toList();
  }
}
