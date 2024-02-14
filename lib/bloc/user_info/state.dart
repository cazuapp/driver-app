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

part of 'bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserInfoState extends Equatable {
  final FormzSubmissionStatus status;

  final UserStatus current;
  final bool isValid;
  final int result;
  final String errmsg;
  final String okmsg;
  final bool available;

  const UserInfoState.initial()
      : this(
          errmsg: "",
          current: UserStatus.initial,
          okmsg: "",
          result: Protocol.empty,
          status: FormzSubmissionStatus.initial,
          isValid: false,
          available: false,
        );

  const UserInfoState({
    required this.errmsg,
    required this.okmsg,
    required this.result,
    required this.current,
    required this.status,
    required this.available,
    required this.isValid,
  });

  UserInfoState copyWith({
    int? result,
    String? errmsg,
    String? okmsg,
    UserStatus? current,
    FormzSubmissionStatus? status,
    bool? available,
    bool? isValid,
  }) {
    return UserInfoState(
        current: current ?? this.current,
        result: result ?? this.result,
        available: available ?? this.available,
        errmsg: errmsg ?? this.errmsg,
        okmsg: okmsg ?? this.okmsg,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [okmsg, errmsg, status, available, current];
}
