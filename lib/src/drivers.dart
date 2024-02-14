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

import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/core/protocol.dart';
import 'package:cazuapp/core/routes.dart';
import 'package:cazuapp/models/driver_stats.dart';

import 'package:cazuapp/models/queryresult.dart';
import 'package:cazuapp/src/cazuapp.dart';

class DriversManager {
  AppInstance instance;

  DriversManager({required this.instance});

  Future<bool?> assign({required int id, required bool action}) async {
    QueryResult? result;

    if (action == true) {
      result = await instance.query.run(destination: AppRoutes.takeOrder, body: {"id": id});
    } else {
      result = await instance.query.run(destination: AppRoutes.untakeOrder, body: {"id": id});
    }

    if (!result!.ok()) {
      return false;
    }

    return true;
  }

  Future<DualResult?> stats({String dateStart = "", String dateEnd = ""}) async {
    QueryResult? result = await instance.query
        .run(destination: AppRoutes.driverStats, body: {"date_start": dateStart, "date_end": dateEnd});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];

    return DualResult(model: DriverStats.fromJson(data), status: Protocol.ok);
  }
}
