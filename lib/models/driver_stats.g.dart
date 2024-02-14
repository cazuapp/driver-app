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

part of 'driver_stats.dart';

DriverStats _$DriverStatsFromJson(Map<String, dynamic> json) => DriverStats(
      ok: json['ok'] ?? 0,
      pending: json['pending'] ?? 0,
      nopayment: json['nopayment'] ?? 0,
      nodriver: json['nodriver'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      other: json['other'] ?? 0,
    );

Map<String, dynamic> _$DriverStatsToJson(DriverStats instance) => <String, dynamic>{'ok': instance.ok};
