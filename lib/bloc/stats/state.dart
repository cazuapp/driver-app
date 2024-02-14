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

enum ServerInfoStatus { initial, loading, success, failure, empty }

class ServerInfoState extends Equatable {
  const ServerInfoState({
    required this.id,
    this.status = ServerInfoStatus.initial,
    required this.driverStats,
    this.dateEnd = "",
    this.dateStart = "",
  });

  ServerInfoState.initial()
      : this(id: 0, status: ServerInfoStatus.initial, driverStats: DriverStats.initial(), dateEnd: "", dateStart: "");

  final ServerInfoStatus status;
  final DriverStats driverStats;
  final int id;
  final String dateEnd;
  final String dateStart;

  ServerInfoState copyWith({
    int? id,
    ServerInfoStatus? status,
    DriverStats? driverStats,
    String? dateStart,
    String? dateEnd,
  }) {
    return ServerInfoState(
      id: id ?? this.id,
      status: status ?? this.status,
      driverStats: driverStats ?? this.driverStats,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
    );
  }

  @override
  List<Object> get props => [id, status, driverStats, dateEnd, dateStart];
}
