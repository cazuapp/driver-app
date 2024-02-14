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
import 'package:cazuapp/bloc/home/bloc.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/models/order_list.dart';
import 'package:cazuapp/views/orders/order_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/* Displayer of home items */

class HomeListItem extends StatelessWidget {
  const HomeListItem({required this.order, required this.current, super.key});

  final OrderList order;
  final String current;

  @override
  Widget build(BuildContext context) {
    int me = context.select((AuthenticationBloc bloc) => bloc.instance.getuser.id);

    var id = order.id.toString();
    var display = "pending";
    Color displayclr = Colors.black;

    switch (order.orderStatus) {
      case "pending":
        display = "Pending";
        displayclr = AppTheme.orange;
        break;

      case "ok":
        display = "ok";
        displayclr = AppTheme.focussecondary;
        break;

      case "delivered":
        display = "Delivered";
        displayclr = AppTheme.secondary;
        break;

      case "nodriver":
        display = "Unable to match driver";
        displayclr = AppTheme.alert;

        break;

      case "cancelled":
        display = "Cancelled";
        displayclr = AppTheme.softred;
        break;

      case "active":
        display = "";
        displayclr = AppTheme.focussecondary;

        break;

      default:
        display = "Error";
        displayclr = AppTheme.alert;

        break;
    }

    var finaldisplay = "";
    if (current == "Active") {
      finaldisplay = "#   ${id.toString()}";
    } else {
      finaldisplay = "#   ${id.toString()} ($display)";
    }

    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().scaleHeight * 5,
          bottom: ScreenUtil().scaleHeight * 20,
          left: ScreenUtil().scaleWidth * 17,
          right: ScreenUtil().scaleWidth * 17,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().scaleHeight * 10,
            horizontal: ScreenUtil().screenWidth * 0.05,
          ),
          decoration: BoxDecoration(
            color: AppTheme.mainbg,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          height: ScreenUtil().scaleHeight * 140,
          child: InkWell(
            onTap: () async {
              await navigate(context, OrderInfoPage(id: order.id, userid: order.userid)).then((result) {
                context.read<HomeBloc>().add(Init());
                context.read<HomeBloc>().add(HomeFetch());
              });
            },
            child: Column(
              children: <Widget>[
                /* We create a row in order to space icons and final display text in between */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        utext(title: finaldisplay, color: displayclr, fontWeight: FontWeight.w500, resize: true),
                      ],
                    ),
                    order.driver == me
                        ? const Icon(FontAwesomeIcons.arrowsTurnToDots, size: 17, color: AppTheme.focuschill2)
                        : const SizedBox.shrink(),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(FontAwesomeIcons.locationDot, color: AppTheme.shallowlockeye, size: 18),
                    SizedBox(width: 10.w),
                    utext(title: "${order.address}, ${order.zip}", fontWeight: FontWeight.w500, resize: true),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(FontAwesomeIcons.house, color: AppTheme.darkgray, size: 18),
                    SizedBox(width: 12.w),
                    utext(title: order.city, fontWeight: FontWeight.w500, resize: true),
                  ],
                ),
                const Divider(),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(FontAwesomeIcons.calendar, color: AppTheme.orange, size: 18),
                        SizedBox(width: 8.w),
                        utext(title: " ${Etc.prettydate(order.created)}", resize: true, fontWeight: FontWeight.w500),
                      ],
                    ),
                    const Icon(FontAwesomeIcons.anglesRight, color: AppTheme.darkgray),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
