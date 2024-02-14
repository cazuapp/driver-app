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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../components/item_extended.dart';
import '../../../core/theme.dart';
import '../../../components/topbar.dart';
import '../../../components/utext.dart';

class WhoAmiPage extends StatelessWidget {
  const WhoAmiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyFlagsForm();
  }
}

class MyFlagsForm extends StatelessWidget {
  const MyFlagsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: const TopBar(title: "Who am I?"),
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
                                  title: "My account",
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
                                        ItemExtended(
                                            input: "First Name",
                                            title: context
                                                .select((AuthenticationBloc bloc) => bloc.instance.getuser.first),
                                            fawesome: FontAwesomeIcons.person),
                                        ItemExtended(
                                            input: "Last name",
                                            title:
                                                context.select((AuthenticationBloc bloc) => bloc.instance.getuser.last),
                                            fawesome: FontAwesomeIcons.signature),
                                        ItemExtended(
                                            input: "Email",
                                            title: context
                                                .select((AuthenticationBloc bloc) => bloc.instance.getuser.email),
                                            fawesome: FontAwesomeIcons.inbox),
                                        ItemExtended(
                                            input: "Created",
                                            title: context
                                                .select((AuthenticationBloc bloc) => bloc.instance.getuser.created),
                                            fawesome: FontAwesomeIcons.calendar),
                                      ]))),
                        ],
                      ),
                    )))));
  }
}
