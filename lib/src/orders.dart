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

import 'dart:developer';

import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/core/protocol.dart';
import 'package:cazuapp/core/routes.dart';
import 'package:cazuapp/models/item.dart';
import 'package:cazuapp/models/order_info.dart';
import 'package:cazuapp/models/order_list.dart';
import 'package:cazuapp/models/queryresult.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:cazuapp/views/orders/status.dart';

extension ParseKeyToString on Param {
  String toShortString() {
    return toString().split('.').last;
  }
}

/* Handles orders */

class OrdersManager {
  AppInstance instance;

  OrdersManager({required this.instance});

  Future<bool?> setcurrent({int id = 0, CurrentStatus action = CurrentStatus.pending}) async {
    QueryResult? result;
    log("Updating order $id with action $action");

    if (action == CurrentStatus.ok) {
      result = await instance.query.run(destination: AppRoutes.deliverOK, body: {"id": id});
    } else if (action == CurrentStatus.nopayment) {
      result = await instance.query.run(destination: AppRoutes.paymentFailed, body: {"id": id, "value": "notpaid"});
    } else if (action == CurrentStatus.pending) {
      result = await instance.query.run(destination: AppRoutes.deliverpending, body: {"id": id});
    }

    if (!result!.ok()) {
      return false;
    }

    return true;
  }

  Future<bool?> setstatus({bool action = false}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.setStatus, body: {"value": action});

    if (!result!.ok()) {
      return false;
    }

    instance.auth.available = action;
    return true;
  }

  Future<DualResult?> getItems({int offset = 0, int limit = 10, int id = 0}) async {
    QueryResult? result =
        await instance.query.run(destination: AppRoutes.getItems, body: {"offset": offset, "limit": limit, "id": id});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var counter = result.data["data"]["count"];
    var data = result.data["data"]["rows"];

    List<Item> items = <Item>[];

    for (var key in data) {
      Item order = Item.fromJson(key);
      items.add(order);
    }

    return DualResult(status: Protocol.ok, model: items, model2: counter);
  }

  Future<DualResult?> search({String text = '', int offset = 0, int limit = 10, Param param = Param.all}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.orderSearchAllBy,
        body: {"value": text, "offset": offset, "limit": limit, "param": param.toShortString()});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: orders, model2: counter);
  }

  Future<DualResult?> ordersMenu(
      {int offset = 0, int limit = 10, Param param = Param.all, String dateStart = "", String dateEnd = ""}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.orderGetAllMine, body: {
      "status": "pending",
      "offset": offset,
      "limit": limit,
      "param": param.toShortString(),
      "date_start": dateStart,
      "date_end": dateEnd
    });

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: orders, model2: counter);
  }

  /*
   * home(): Returns pending orders to be displayed in the main page
   * 
   * @return (DualResult):
   * 
   *          · List<OrderList>: List of pending orders
   *
   * @error (DualResult):
   *
   *          · [Error]: error list.
   */

  Future<DualResult?> home({int offset = 0, int limit = 10, Param param = Param.all}) async {
    QueryResult? result = await instance.query.run(
        destination: AppRoutes.orderGetAllBy,
        body: {"status": "pending", "offset": offset, "limit": limit, "param": param.toShortString()});

    if (!result!.ok()) {
      return result.errorAsDual();
    }

    var data = result.data["data"];
    List<OrderList> orders = <OrderList>[];

    for (var key in data) {
      OrderList order = OrderList.fromJson(key);
      orders.add(order);
    }

    var counter = result.data["counter"];

    return DualResult(status: Protocol.ok, model: orders, model2: counter);
  }

  /*
   * info(): Returns information on a given orders.
   * 
   * @return (DualResult):
   * 
   *          · OrderList: Returning information.
   *
   * @error (DualResult):
   *
   *          · [Error]: error list.
   */

  Future<DualResult?> info({required int id}) async {
    QueryResult? result = await instance.query.run(destination: AppRoutes.orderInfo, body: {"id": id});

    if (!result!.ok()) {
      return DualResult(model: null, status: Protocol.unknownError);
    }

    var data = result.data["data"];
    OrderInfo order = OrderInfo.fromJson(data);

    return DualResult(model: order, status: Protocol.ok);
  }
}
