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

class OrdersEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetText extends OrdersEvent {
  SetText({required this.text});

  final String text;

  @override
  List<Object> get props => [text];
}

class SetParam extends OrdersEvent {
  SetParam({required this.param, required this.text});

  final Param param;
  final String text;

  @override
  List<Object> get props => [param, text];
}

class SetDate extends OrdersEvent {
  SetDate({required this.dateStart, required this.dateEnd});

  final String dateStart;
  final String dateEnd;

  @override
  List<Object> get props => [dateStart, dateEnd];
}

class Init extends OrdersEvent {}

class OrdersFetch extends OrdersEvent {}

class OnHomeScroll extends OrdersEvent {}
