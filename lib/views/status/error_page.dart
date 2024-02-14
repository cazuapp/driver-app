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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme.dart';
import '../../../components/utext.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ErrorPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: ErrorPageForm(),
    );
  }
}

class ErrorPageForm extends StatelessWidget {
  const ErrorPageForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
      String errmsg = context.select((AuthenticationBloc bloc) => bloc.instance.query.lasterr);
      return Scaffold(
          backgroundColor: AppTheme.white,
          appBar: null,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, // transparent status bar
                statusBarIconBrightness: Brightness.dark, // status bar icons' color
              ),
              child: SafeArea(
                  child: SizedBox(
                      height: size.height,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 0,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(FontAwesomeIcons.microscope, size: 49, color: AppTheme.alert),
                                          const SizedBox(height: 35),
                                          utext(
                                              title: "An error has occured",
                                              fontSize: 20,
                                              color: AppTheme.main,
                                              align: Alignment.center,
                                              fontWeight: FontWeight.w400,
                                              textAlign: TextAlign.center),
                                          const SizedBox(height: 15),
                                          utext(
                                              align: Alignment.center,
                                              title: errmsg,
                                              textAlign: TextAlign.center,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromARGB(159, 18, 18, 18)),
                                          const SizedBox(height: 25),
                                        ]))
                              ]))))));
    });
  }
}
