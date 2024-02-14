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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../core/protocol.dart';
import '../../../src/cazuapp.dart';

part 'event.dart';
part 'state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final AppInstance instance;

  UserInfoBloc({required this.instance}) : super(const UserInfoState.initial()) {
    on<LoadBase>(_onLoadBase);
    on<UsersInfoEventOK>(_onOK);
    on<SetStatus>(_onSetStatus);
    on<GetStatus>(_onGetStatus);
  }

  Future<void> _onGetStatus(GetStatus event, Emitter<UserInfoState> emit) async {
    emit(state.copyWith(current: UserStatus.success, result: Protocol.ok, available: instance.auth.available));
  }

  Future<void> _onSetStatus(SetStatus event, Emitter<UserInfoState> emit) async {
    final status = event.status;

    bool? result = await instance.orders.setstatus(action: status);

    emit(state.copyWith(result: Protocol.ok, available: result == true ? status : state.available));
  }

  Future<void> _onLoadBase(LoadBase event, Emitter<UserInfoState> emit) async {
    await instance.setup();
    emit(state.copyWith(current: UserStatus.success));
  }

  void _onOK(UsersInfoEventOK event, Emitter<UserInfoState> emit) {
    emit(const UserInfoState.initial());
  }
}
