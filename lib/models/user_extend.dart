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

part 'user_extend.g.dart';

@JsonSerializable()
class UserExtend {
  final int id;

  late bool isDriver;

  final String email;

  final String fullname;

  final String first;

  final String last;

  final bool verified;

  late bool driverStatus;

  final bool available;

  final String created;

  UserExtend(
      {required this.id,
      required this.available,
      required this.created,
      required this.driverStatus,
      required this.fullname,
      required this.first,
      required this.last,
      required this.email,
      required this.verified});

  UserExtend.initial()
      : this(
            id: 0,
            available: false,
            created: "",
            first: "",
            last: "",
            driverStatus: false,
            fullname: "",
            email: "",
            verified: false);

  factory UserExtend.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  UserExtend copyWith({
    bool? ableToOrder,
    bool? health,
    int? id,
    String? email,
    String? first,
    String? last,
    bool? available,
    int? favorites,
    bool? driverStatus,
    String? fullname,
    bool? verified,
    int? banCode,
  }) {
    return UserExtend(
      available: available ?? this.available,
      created: created,
      driverStatus: driverStatus ?? this.driverStatus,
      fullname: fullname ?? this.fullname,
      verified: verified ?? this.verified,
      id: id ?? this.id,
      email: email ?? this.email,
      first: first ?? this.first,
      last: last ?? this.last,
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
