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
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/components/topbar.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/models/order_info.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* StatusInfoPage Displays current status on a given order */

class StatusInfoPage extends StatelessWidget {
  const StatusInfoPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OrderManagerBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
          ..add(OrderInfoRequest(id: id)),
        child: const RadioStatus(),
      ),
    );
  }
}

enum CurrentStatus { ok, nopayment, pending }

class RadioStatus extends StatefulWidget {
  const RadioStatus({super.key});

  @override
  State<RadioStatus> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioStatus> {
  CurrentStatus? _radio;

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

      OrderInfo order = state.info;

      if (order.orderStatus == "pending") {
        context.read<OrderManagerBloc>().add(const SetAux(value: CurrentStatus.pending));
        _radio = CurrentStatus.pending;
      } else if (order.orderStatus == "ok") {
        context.read<OrderManagerBloc>().add(const SetAux(value: CurrentStatus.ok));
        _radio = CurrentStatus.ok;
      } else if (order.orderStatus == "nopayment") {
        context.read<OrderManagerBloc>().add(const SetAux(value: CurrentStatus.nopayment));
        _radio = CurrentStatus.nopayment;
      }

      return Scaffold(
          backgroundColor: AppTheme.white,
          appBar: TopBar(title: "Order #${order.id.toString()}"),
          body: SafeArea(
              child: SizedBox(
                  height: size.height,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          const SizedBox(height: 16),
                          Container(
                              alignment: Alignment.topLeft,
                              child: utext(
                                  fontSize: 14, title: "Status", color: AppTheme.title, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 6),
                          InkWell(
                              onTap: () {
                                context
                                    .read<OrderManagerBloc>()
                                    .add(SetStatus(id: order.id, action: CurrentStatus.pending));
                              },
                              child: ListTile(
                                title: utext(title: 'Pending'),
                                leading: Radio<CurrentStatus>(
                                  value: CurrentStatus.pending,
                                  groupValue: _radio,
                                  activeColor: _radio == CurrentStatus.pending ? AppTheme.lockeye2 : null,
                                  onChanged: (CurrentStatus? value) {
                                    context
                                        .read<OrderManagerBloc>()
                                        .add(SetStatus(id: order.id, action: CurrentStatus.pending));
                                  },
                                ),
                              )),
                          const Divider(),
                          InkWell(
                              onTap: () {
                                context.read<OrderManagerBloc>().add(SetStatus(id: order.id, action: CurrentStatus.ok));
                              },
                              child: ListTile(
                                title: utext(title: 'OK'),
                                leading: Radio<CurrentStatus>(
                                  value: CurrentStatus.ok,
                                  groupValue: _radio,
                                  activeColor: _radio == CurrentStatus.ok ? AppTheme.lockeye2 : null,
                                  onChanged: (CurrentStatus? value) {
                                    context
                                        .read<OrderManagerBloc>()
                                        .add(SetStatus(id: order.id, action: CurrentStatus.ok));
                                  },
                                ),
                              )),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              context
                                  .read<OrderManagerBloc>()
                                  .add(SetStatus(id: order.id, action: CurrentStatus.nopayment));
                            },
                            child: ListTile(
                              title: utext(title: 'No payment'),
                              leading: Radio<CurrentStatus>(
                                value: CurrentStatus.nopayment,
                                groupValue: _radio,
                                activeColor: _radio == CurrentStatus.nopayment ? AppTheme.lockeye2 : null,
                                onChanged: (CurrentStatus? value) {
                                  context
                                      .read<OrderManagerBloc>()
                                      .add(SetStatus(id: order.id, action: CurrentStatus.nopayment));
                                },
                              ),
                            ),
                          )
                        ],
                      ))))));
    });
  }
}
