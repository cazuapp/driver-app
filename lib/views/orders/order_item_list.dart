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

import 'package:cazuapp/models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/utext.dart';
import '../../../core/theme.dart';

class OrderItemList extends StatefulWidget {
  final Item item;
  final int index;

  const OrderItemList({required this.index, required this.item, super.key});

  @override
  State<OrderItemList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderItemList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: const EdgeInsets.only(top: 5),
      child: Container(
          color: AppTheme.white,
          child: Table(
            border: TableBorder.symmetric(
              outside: const BorderSide(width: 1, color: AppTheme.black, style: BorderStyle.solid),
              inside: const BorderSide(width: 1, color: AppTheme.black, style: BorderStyle.solid),
            ),
            children: [
              TableRow(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: utext(
                      resize: true,
                      shrink: true,
                      title: widget.item.variantHistoric,
                      fontWeight: FontWeight.w600,
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: utext(
                        textAlign: TextAlign.center,
                        align: Alignment.center,
                        resize: true,
                        shrink: true,
                        title: widget.item.quantity.toString())),
                Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: utext(
                        align: Alignment.center,
                        textAlign: TextAlign.center,
                        resize: true,
                        shrink: true,
                        title: "\$${widget.item.total.toString()}"))
              ])
            ],
          )),
    );
  }
}
