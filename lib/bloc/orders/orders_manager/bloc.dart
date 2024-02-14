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

import 'dart:developer';

import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/models/order_info.dart';
import 'package:cazuapp/views/orders/status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/protocol.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class OrderManagerBloc extends Bloc<OrderManagerEvent, OrderManagerState> {
  final AppInstance instance;

  OrderManagerBloc({required this.instance}) : super(const OrderManagerState.initial()) {
    on<OrderInfoRequest>(_onInfoRequest);
    on<OrderAssignAction>(_onAssignAction);
    on<SetStatus>(_onSetStatus);
    on<SetAux>(_onSetAux);
  }

  Future<void> _onSetAux(SetAux event, Emitter<OrderManagerState> emit) async {
    final value = event.value;

    emit(state.copyWith(aux: value, current: OrderStatus.success));
  }

  Future<void> _onSetStatus(SetStatus event, Emitter<OrderManagerState> emit) async {
    final id = event.id;
    final CurrentStatus action = event.action;

    bool? result1 = await instance.orders.setcurrent(id: id, action: action);

    /* Unable to update an order's status */

    if (!result1!) {
      return;
    }

    /* Retrieve orders' info */

    DualResult? result = await instance.orders.info(id: id);
    if (result?.status == Protocol.ok) {
      emit(state.copyWith(status: Protocol.ok, current: OrderStatus.success, info: result?.model));
    } else {
      String? errmsg = "Error while processing request";

      emit(state.copyWith(status: result?.status, errmsg: errmsg, current: OrderStatus.failure));
    }
  }

  Future<void> _onAssignAction(OrderAssignAction event, Emitter<OrderManagerState> emit) async {
    final id = event.id;
    final bool action = event.action;

    await instance.drivers.assign(id: id, action: action);

    DualResult? result = await instance.orders.info(id: id);
    if (result?.status == Protocol.ok) {
      emit(state.copyWith(status: Protocol.ok, current: OrderStatus.success, info: result?.model));
    } else {
      String? errmsg = "Error while processing request";

      emit(state.copyWith(status: result?.status, errmsg: errmsg, current: OrderStatus.failure));
    }
  }

  Future<void> _onInfoRequest(OrderInfoRequest event, Emitter<OrderManagerState> emit) async {
    final id = event.id;

    log("Requesting order information id on $id");

    // emit(state.copyWith(current: OrderStatus.loading));
    String? errmsg = "Error while processing request";

    try {
      DualResult? result = await instance.orders.info(id: id);

      switch (result?.status) {
        case Protocol.empty:
          errmsg = "Unable to locate order";
          break;

        case Protocol.invalidParam:
          errmsg = "Unable to locate order";
          break;
      }

      if (result?.status == Protocol.ok) {
        emit(state.copyWith(status: Protocol.ok, current: OrderStatus.success, info: result?.model));
      } else {
        emit(state.copyWith(status: result?.status, errmsg: errmsg, current: OrderStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(status: Protocol.unknownError, current: OrderStatus.failure));
    }
  }
}
