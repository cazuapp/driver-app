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

import 'package:cazuapp/bloc/auth/bloc.dart';
import 'package:cazuapp/bloc/orders/orders_manager/bloc.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/item_account.dart';
import 'package:cazuapp/components/item_extended.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/models/order_info.dart';
import 'package:cazuapp/views/address/address_historic.dart';
import 'package:cazuapp/views/orders/order_items.dart';
import 'package:cazuapp/views/orders/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class OrderInfoPage extends StatelessWidget {
  const OrderInfoPage({super.key, required this.userid, required this.id});

  final int id;
  final int userid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OrderManagerBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(OrderInfoRequest(id: id)),
        child: OrderInfoForm(userid: userid),
      ),
    );
  }
}

class OrderInfoForm extends StatelessWidget {
  const OrderInfoForm({super.key, required this.userid});

  final int userid;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FocusManager.instance.primaryFocus?.unfocus();

    return BlocBuilder<OrderManagerBloc, OrderManagerState>(builder: (context, state) {
      switch (state.current) {
        case OrderStatus.initial:
          return const Loader();
        case OrderStatus.loading:
          return const Loader();

        case OrderStatus.failure:
          return const FailurePage(title: "Orders list", subtitle: "Error loading orders");
        case OrderStatus.success:
          break;
      }

      bool isCancelled = false;

      OrderInfo order = state.info;
      bool isMine = false;

      bool amIAvailable = context.select((AuthenticationBloc bloc) => bloc.instance.auth.available);

      if (state.info.driver == context.select((AuthenticationBloc bloc) => bloc.instance.getuser.id)) {
        isMine = true;
      }

      String display = "";

      switch (order.orderStatus) {
        case "pending":
          display = "Pending";

          break;
        case "ok":
          display = "ok";

          break;

        case "delivered":
          display = "Delivered";
          break;

        case "nodriver":
          display = "Unable to match driver";

          break;
        case "nopayment":
          display = "No Payment";

          break;
        case "active":
          display = "";

          break;

        case "cancelled":
          isCancelled = true;
          display = "Cancelled";

          break;

        default:
          display = "Error";

          break;
      }

      return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: TopBar(title: "Order #${order.id.toString()}"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                                alignment: Alignment.topLeft,
                                child: utext(
                                    fontSize: 14,
                                    title: "#${order.id.toString()}",
                                    color: AppTheme.title,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(width: 1, color: Colors.white)),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          state.info.orderStatus != "ok" &&
                                                  ((state.info.driver == 0 && amIAvailable) || isMine)
                                              ? InkWell(
                                                  child: Container(
                                                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                                                      child: Stack(children: <Widget>[
                                                        GestureDetector(
                                                          child: ListTile(
                                                            visualDensity:
                                                                const VisualDensity(horizontal: -1, vertical: -1),
                                                            leading: const Icon(FontAwesomeIcons.arrowsTurnToDots,
                                                                color: AppTheme.black),
                                                            trailing: Switch(
                                                              inactiveTrackColor: AppTheme.white,
                                                              activeColor: AppTheme.lockeye,
                                                              inactiveThumbColor: AppTheme.lightblue,
                                                              value: isMine,
                                                              onChanged: (value) {
                                                                BlocProvider.of<OrderManagerBloc>(context)
                                                                    .add(OrderAssignAction(
                                                                  action: isMine ? false : true,
                                                                  id: state.info.id,
                                                                ));
                                                              },
                                                            ),
                                                            title: utext(
                                                              title: "Take order",
                                                              fontSize: 16.0,
                                                              color: AppTheme.black,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ])))
                                              : const SizedBox.shrink(),
                                          ItemExtended(
                                            red: isCancelled ? true : false,
                                            input: "Order status",
                                            title: display,
                                            fawesome: FontAwesomeIcons.arrowDownUpLock,
                                            onTap: isMine
                                                ? () async {
                                                    await navigate(
                                                      context,
                                                      StatusInfoPage(
                                                        id: order.id,
                                                      ),
                                                    ).then((result) {
                                                      context
                                                          .read<OrderManagerBloc>()
                                                          .add(OrderInfoRequest(id: order.id));
                                                    });
                                                  }
                                                : null, // Set onTap to null if isMine is false
                                          ),
                                          ItemExtended(
                                            input: "Driver",
                                            title: state.info.driver == 0
                                                ? "No driver assigned"
                                                : "${state.info.driverFirst} ${state.info.driverLast}",
                                            fawesome: state.info.driver != 0
                                                ? FontAwesomeIcons.motorcycle
                                                : FontAwesomeIcons.solidCircleXmark,
                                          ),
                                          ItemExtended(
                                            input: "Placed by",
                                            title: "${order.userFirst} ${order.userLast}",
                                            fawesome: FontAwesomeIcons.user,
                                          ),
                                          ItemAccount(
                                              title: "View all items",
                                              fawesome: FontAwesomeIcons.list,
                                              onTap: () {
                                                navigate(context, OrderItemsPage(id: order.id));
                                              }),
                                          ItemExtended(
                                              input: "Address",
                                              title: order.addressName,
                                              fawesome: FontAwesomeIcons.locationDot,
                                              onTap: () {
                                                navigate(context,
                                                    AddressHistoricDataPage(id: order.id, userid: order.userid));
                                              }),
                                          ItemExtended(
                                            input: "Created",
                                            title: Etc.prettydate(order.created),
                                            fawesome: FontAwesomeIcons.calendar,
                                          ),
                                          ItemExtended(
                                            input: "Total",
                                            title: "\$${order.total.toString()}",
                                            fawesome: FontAwesomeIcons.moneyBillTrendUp,
                                          ),
                                          ItemExtended(
                                            input: "Shipping total",
                                            title: "\$${order.shipping.toString()}",
                                            fawesome: FontAwesomeIcons.moneyBillTransfer,
                                          ),
                                          ItemExtended(
                                            input: "Total + taxes",
                                            title: "\$${order.totalTaxShipping.toString()}",
                                            fawesome: FontAwesomeIcons.moneyCheck,
                                          ),
                                        ]))),
                          ],
                        ),
                      )))));
    });
  }
}
