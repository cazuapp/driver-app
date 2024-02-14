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

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  AppInstance instance;

  HomeBloc({required this.instance}) : super(const HomeState()) {
    on<HomeFetch>(
      _onHomeFetch,
      transformer: throttleDroppable(throttleDuration),
    );

    /* Resets original status */

    on<Init>(_onInit);

    /* Set parameter (assigned to me or all pending) */
    on<SetParam>(_onSetParam);
  }

  Future<void> _onSetParam(
    SetParam event,
    Emitter<HomeState> emit,
  ) async {
    final change = event.param;

    emit(state.copyWith(param: change));
  }

  Future<void> _onInit(
    Init event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeState());
  }

  Future<void> _onHomeFetch(
    HomeFetch event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state.status == HomeStatus.initial) {
        final posts = await _fetchHomeItems(emit: emit);

        return emit(
          state.copyWith(
            status: HomeStatus.success,
            orders: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts = await _fetchHomeItems(emit: emit, startIndex: state.orders.length);

      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: HomeStatus.success,
                orders: List.of(state.orders)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<List<OrderList>> _fetchHomeItems({required Emitter<HomeState> emit, int startIndex = 0}) async {
    DualResult? response = await instance.orders.home(offset: startIndex, limit: _postLimit, param: state.param);

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
