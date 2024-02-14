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

import 'package:cazuapp/models/driver_stats.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/dual.dart';

import '../../../core/protocol.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class ServerInfoBloc extends Bloc<ServerInfoEvent, ServerInfoState> {
  final AppInstance instance;

  ServerInfoBloc({required this.instance}) : super(ServerInfoState.initial()) {
    on<ServerInfoEventOK>(_onOK);
    on<FetchDriverStats>(_onFetchDriverStats);
    on<SetDate>(_onSetDate);
  }

  Future<void> _onSetDate(
    SetDate event,
    Emitter<ServerInfoState> emit,
  ) async {
    final changeEnd = event.dateEnd;
    final changeStart = event.dateStart;

    emit(state.copyWith(dateEnd: changeEnd, dateStart: changeStart));
  }

  Future<void> _onOK(ServerInfoEventOK event, Emitter<ServerInfoState> emit) async {
    emit(ServerInfoState.initial());
  }

  Future<void> _onFetchDriverStats(FetchDriverStats event, Emitter<ServerInfoState> emit) async {
    /* Retrieve drivers' stats */

    DualResult? response = await instance.drivers.stats(dateStart: state.dateStart, dateEnd: state.dateEnd);

    if (response?.status == Protocol.ok) {
      emit(state.copyWith(status: ServerInfoStatus.success, driverStats: response?.model));
    }

    if (response?.status == Protocol.empty) {
      emit(state.copyWith(status: ServerInfoStatus.empty));
    }
  }
}
