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

abstract class AppInfoEvent extends Equatable {
  const AppInfoEvent();

  @override
  List<Object> get props => [];
}

class SetRefresh extends AppInfoEvent {
  const SetRefresh({required this.value});

  final bool value;

  @override
  List<Object> get props => [value];
}

class StatusChange extends AppInfoEvent {
  const StatusChange(this.value);

  final AppLifecycleState value;

  @override
  List<Object> get props => [value];
}

class TapChange extends AppInfoEvent {
  const TapChange({required this.value, this.location});

  final TapAction value;
  final dynamic location;

  @override
  List<Object> get props => [value, location];
}
