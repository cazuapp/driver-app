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

part of 'server.dart';

Server _$ServerFromJson(Map<String, dynamic> json) =>
    Server(version: json['version'] as String, date: json['date'] ?? 0, expires: json['expires'] ?? 0);

Map<String, dynamic> _$ServerToJson(Server instance) =>
    <String, dynamic>{'version': instance.version, 'date': instance.date};
