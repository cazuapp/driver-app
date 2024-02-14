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

enum HomeSearchStatus { loading, initial, success, failure }

class HomeSearchState extends Equatable {
  final HomeSearchStatus status;
  final bool hasReachedMax;
  final List<OrderList> orders;
  final int total;
  final String text;
  final Param param;

  const HomeSearchState({
    this.status = HomeSearchStatus.initial,
    this.hasReachedMax = false,
    this.orders = const <OrderList>[],
    this.total = 0,
    this.text = '',
    this.param = Param.all,
  });

  HomeSearchState copyWith({
    String? text,
    Param? param,
    HomeSearchStatus? status,
    int? total,
    List<OrderList>? orders,
    bool? hasReachedMax,
  }) {
    return HomeSearchState(
      param: param ?? this.param,
      text: text ?? this.text,
      status: status ?? this.status,
      total: total ?? this.total,
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''HomeStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, orders, total, hasReachedMax, text, param];
}
