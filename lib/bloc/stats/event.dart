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

abstract class ServerInfoEvent extends Equatable {
  const ServerInfoEvent();
}

class ServerInfoEventOK extends ServerInfoEvent {
  const ServerInfoEventOK();

  @override
  List<Object> get props => [];
}

class ServerInfoRequest extends ServerInfoEvent {
  const ServerInfoRequest();

  @override
  List<Object> get props => [];
}

class FetchDriverStats extends ServerInfoEvent {
  const FetchDriverStats();

  @override
  List<Object> get props => [];
}

class SetDate extends ServerInfoEvent {
  const SetDate({required this.dateStart, required this.dateEnd});

  final String dateStart;
  final String dateEnd;

  @override
  List<Object> get props => [dateStart, dateEnd];
}

class ServerResetCache extends ServerInfoEvent {
  const ServerResetCache();

  @override
  List<Object> get props => [];
}
