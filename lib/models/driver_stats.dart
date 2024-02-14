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

import 'package:json_annotation/json_annotation.dart';

part 'driver_stats.g.dart';

@JsonSerializable()
class DriverStats {
  final int ok;
  final int pending;
  final int nopayment;
  final int nodriver;
  final int cancelled;
  final int other;

  DriverStats(
      {required this.ok,
      required this.pending,
      required this.nopayment,
      required this.nodriver,
      required this.cancelled,
      required this.other});

  DriverStats.initial() : this(ok: 0, pending: 0, nopayment: 0, cancelled: 0, nodriver: 0, other: 0);

  factory DriverStats.fromJson(Map<String, dynamic> json) => _$DriverStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DriverStatsToJson(this);
}
