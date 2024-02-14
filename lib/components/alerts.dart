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

import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cazuapp/core/defaults.dart';

SnackBar buildAlert(String message) {
  return SnackBar(
      duration: const Duration(seconds: AppDefaults.snackbar),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
      ),
      backgroundColor: AppTheme.remove,
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              size: 23,
              FontAwesomeIcons.circleXmark,
              color: Colors.white,
            ),
            SizedBox(width: 10.w),
            utext(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                title: message,
                color: Colors.white)
          ]));
}
