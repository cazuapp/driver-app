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

enum OrdersStatus { loading, initial, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final bool hasReachedMax;
  final List<OrderList> orders;
  final Param param;
  final String text;
  final String dateEnd;
  final String dateStart;
  final int total;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.hasReachedMax = false,
    this.orders = const <OrderList>[],
    this.param = Param.all,
    this.text = "All",
    this.dateEnd = "",
    this.dateStart = "",
    this.total = 0,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    String? text,
    List<OrderList>? orders,
    bool? hasReachedMax,
    Param? param,
    String? dateStart,
    String? dateEnd,
    int? total,
  }) {
    return OrdersState(
      param: param ?? this.param,
      text: text ?? this.text,
      status: status ?? this.status,
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      total: total ?? this.total,
    );
  }

  @override
  String toString() {
    return '''HomeStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, orders, hasReachedMax, param, text, dateEnd, dateStart, total];
}
