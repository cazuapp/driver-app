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
import 'package:cazuapp/bloc/user_info/bloc.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/item_account.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/components/topbar.dart';
import 'package:cazuapp/views/account/store.dart';
import 'package:cazuapp/views/account/whoami.dart';
import 'package:cazuapp/views/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme.dart';
import '../../../components/utext.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                UserInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(const GetStatus())),
      ],
      child: const AccountForm(),
    );
  }
}

class AccountForm extends StatefulWidget {
  const AccountForm({super.key});

  @override
  State<AccountForm> createState() => AccountFormState();
}

class AccountFormState extends State<AccountForm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return BlocBuilder<UserInfoBloc, UserInfoState>(builder: (context, state) {
      switch (state.current) {
        case UserStatus.initial:
          return const Loader();
        case UserStatus.loading:
          return const Loader();

        case UserStatus.failure:
          return const FailurePage(title: "Orders list", subtitle: "Error loading orders");
        case UserStatus.success:
          break;
      }

      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: TopBar(title: context.select((AuthenticationBloc bloc) => bloc.instance.getuser.first)),
        body: SafeArea(
          child: SizedBox(
              height: size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.03),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      Container(
                          alignment: Alignment.topLeft,
                          child: utext(
                              fontSize: 14, title: "Account", color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                    child: Container(
                                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                                        child: Stack(children: <Widget>[
                                          GestureDetector(
                                            child: ListTile(
                                              visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
                                              leading: const Icon(FontAwesomeIcons.solidBell, color: AppTheme.black),
                                              trailing: Switch(
                                                activeColor: AppTheme.iconcolors,
                                                inactiveThumbColor: AppTheme.iconcolors,
                                                value: state.available,
                                                onChanged: (value) {
                                                  setState(() {
                                                    BlocProvider.of<UserInfoBloc>(context)
                                                        .add(SetStatus(status: value));
                                                  });
                                                },
                                              ),
                                              title: utext(
                                                title: "Available",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ]))),
                                ItemAccount(
                                    title: "Store information",
                                    fawesome: FontAwesomeIcons.store,
                                    onTap: () => {navigate(context, const StorePage())}),
                                ItemAccount(
                                    title: "Statistics",
                                    fawesome: FontAwesomeIcons.arrowDown19,
                                    onTap: () => {
                                          navigate(context, const DriverStatsPage()),
                                        }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                          alignment: Alignment.topLeft,
                          child: utext(
                              fontSize: 14, title: "Session", color: AppTheme.title, fontWeight: FontWeight.w500)),
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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 6),
                                  ItemAccount(
                                      title: "Who am I?",
                                      fawesome: FontAwesomeIcons.person,
                                      onTap: () => {
                                            navigate(context, const WhoAmiPage()),
                                          }),
                                  ItemAccount(
                                      title: "Logout",
                                      fawesome: FontAwesomeIcons.rightFromBracket,
                                      onTap: () =>
                                          {context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested())}),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }
}
