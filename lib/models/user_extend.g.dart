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

part of 'user_extend.dart';

UserExtend _$UserFromJson(Map<String, dynamic> json) => UserExtend(
    id: json['id'],
    created: json['created'] ?? "",
    available: json['available'] ?? false,
    first: json['first'],
    fullname: json['fullname'] ?? "",
    driverStatus: json['driver_status'] ?? false,
    last: json['last'],
    email: json['email'],
    verified: json['verified'] ?? false);

Map<String, dynamic> _$UserToJson(UserExtend instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first': instance.first,
      'last': instance.last,
      'verified': instance.verified
    };
