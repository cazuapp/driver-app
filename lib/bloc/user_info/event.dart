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

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object> get props => [];
}

class UsersInfoBlocKeyChanged extends UserInfoEvent {
  const UsersInfoBlocKeyChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class UsersInfoEventOK extends UserInfoEvent {
  const UsersInfoEventOK();

  @override
  List<Object> get props => [];
}

class UsersInfoSubmitted extends UserInfoEvent {
  const UsersInfoSubmitted();
}

class UserProgress extends UserInfoEvent {
  const UserProgress({required this.value});

  final String value;

  @override
  List<Object> get props => [value];
}

class LoadBase extends UserInfoEvent {
  const LoadBase();

  @override
  List<Object> get props => [];
}

class GetStatus extends UserInfoEvent {
  const GetStatus();

  @override
  List<Object> get props => [];
}

class SetStatus extends UserInfoEvent {
  const SetStatus({required this.status});

  final bool status;

  @override
  List<Object> get props => [status];
}
