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

import 'package:cazuapp/bloc/auth/repository.dart';
import 'package:cazuapp/components/dual.dart';
import 'package:cazuapp/core/protocol.dart';
import 'package:cazuapp/core/routes.dart';
import 'package:cazuapp/models/queryresult.dart';
import 'package:cazuapp/models/server.dart';
import 'package:cazuapp/models/user.dart';
import 'package:cazuapp/src/cazuapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  AppInstance instance;

  String token = "";
  late bool available;

  AuthManager({required this.instance});

  Future<void> init() async {}

  Future<void> resetdb() async {
    /* Reset all shared preferences data */

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  Future<void> logout({query = true}) async {
    if (!query) {
      await instance.query.run(destination: AppRoutes.userLogout, body: {});
    }

    await clean();

    instance.authenticationRepository?.controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> nointernet() async {
    instance.authenticationRepository?.controller.add(AuthenticationStatus.nointernet);
  }

  Future<void> maint() async {
    await clean();
    instance.authenticationRepository?.controller.add(AuthenticationStatus.maint);
  }

  Future<void> error({String msg = ""}) async {
    await clean();
    instance.authenticationRepository?.controller.add(AuthenticationStatus.error);
  }

/* Sets an user as banned */

  Future<void> banned() async {
    await clean();

    instance.authenticationRepository?.controller.add(AuthenticationStatus.banned);
  }

  Future<DualResult?> login(
      {required String email, required String password, bool remember = false, bool doSetup = false}) async {
    log('Logging using $email');

    QueryResult? result = await instance.query.run(
        doLogin: false,
        startup: true,
        devicedata: true,
        destination: AppRoutes.login,
        body: {"email": email, "password": password});

    if (!result!.ok()) {
      if (result.geterror() == Protocol.banned) {
        await banned();
        return DualResult.initial();
      }

      return result.errorAsDual();
    }

    token = result.data["login"]["token"];

    /* We keep a copy of the login token if remember param has been provided */

    if (remember) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('login_email', email);
      await prefs.setString('login_password', password);
    }

    if (doSetup) {
      await instance.setup();
    }

    await resetall();

    instance.setserver = Server.fromJson(result.data["server"]);

    instance.setuser = User.fromJson(result.data["login"]);
    instance.authenticationRepository?.controller.add(AuthenticationStatus.authenticated);
    instance.auth.available = result.data["available"];
    return DualResult(status: Protocol.ok);
  }

  Future<void> resetall() async {}

  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? login = prefs.getString('login_email');
    final String? loginPassword = prefs.getString('login_password');

    if (login != null && loginPassword != null) {
      await this.login(email: login, password: loginPassword, remember: true);
    }
  }

  /*
   * clean(): Clean logging data.
   * This function basically removes all data stored in the sharedpreferences and resets initial
   * logging models.
   */

  Future<void> clean() async {
    token = "";

    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.clear();

    instance.setuser = User.initial();
    instance.setserver = Server.initial();
    // instance.firstping = FirstPing.initial();
  }
}
