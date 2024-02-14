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

/*
 * Main class. AppInstance contains all inits to other classes.
 * This class is in charge of handling other classes and to
 * manipulate data as requested.
 * 
 * AppInstance is singleton and is initialized only once.
 */

import 'dart:developer';
import 'dart:io';

import 'package:cazuapp/bloc/auth/repository.dart';
import 'package:cazuapp/core/httpr.dart';
import 'package:cazuapp/core/routes.dart';
import 'package:cazuapp/models/first_ping.dart';
import 'package:cazuapp/models/queryresult.dart';
import 'package:cazuapp/components/request.dart';
import 'package:cazuapp/models/server.dart';
import 'package:cazuapp/models/user.dart';
import 'package:cazuapp/src/api.dart';
import 'package:cazuapp/src/auth.dart';
import 'package:cazuapp/src/drivers.dart';
import 'package:cazuapp/src/orders.dart';
import 'package:cazuapp/src/settings.dart';
import 'package:cazuapp/src/stats.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

class AppInstance {
  /* Whether geolocation is enabled */

  bool geoEnabled = false;

  /* Location's permissions */

  late LocationPermission? permission;

  /* Current user's position */

  Position? position;

  /* Initial ping data */

  late FirstPing firstping;

  /* Order manager */

  late OrdersManager orders;

  /* Driver manager */

  late DriversManager drivers;

  /* First ping model */

  late SettingsManager settings;

  /* Auth manager */

  late AuthManager auth;

  /* Instance's stats */

  late Stats? stats;

  late User _user;
  User get getuser => _user;

  Server? _server;
  Server? get getserver => _server;

  set setuser(User usr) => _user = usr;
  set setserver(Server srv) => _server = srv;

  AuthenticationRepository? authenticationRepository;

  static final AppInstance instance = AppInstance.build();

  /* Time at which app was installed */

  late String installed;

  /* Operating system this app is running on top of */

  late String os;

  /* O.S's version */

  late String version;

/* Time at which AppInstance was initialized */

  late DateTime startup;

  late QueryManager query;

  factory AppInstance() {
    return instance;
  }

  AppInstance.build() {
    _user = User.initial();
    authenticationRepository = AuthenticationRepository(instance: this);
    auth = AuthManager(instance: this);
    orders = OrdersManager(instance: this);
    drivers = DriversManager(instance: this);
    startup = DateTime.now();
    os = Platform.operatingSystem;
    version = Platform.operatingSystemVersion;
    stats = Stats();
    query = QueryManager(instance: this);
    settings = SettingsManager(instance: this);

    if (kIsWeb) {
      SystemNavigator.pop();
      exit(0);
    }
  }

/* Loads initial settings */

  Future<void> setup() async {
    await instance.settings.loadSettings();
  }

  Future<void> getlocation() async {
    geoEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      } else {
        position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future shutdown() async {
    _user = User.initial();
    _server = null;
  }

  Future<bool?> pingServer({bool login = false}) async {
    log('First ping');

    /* doLogin basically means that this query does not need to use login token */

    QueryResult? result = await query.run(doLogin: login, type: RequestType.get, destination: AppRoutes.initPing);

    if (!result!.ok()) {
      if (result.getStatus() == Httpr.maint) {
        await instance.auth.maint();
      }

      log("Error while booting");
      return false;
    }

    var data = result.data["data"];

    firstping = FirstPing.fromJson(data);

    if (firstping.maint == true) {
      log("Server is under maintaince");
      await instance.auth.maint();
      return false;
    }

    return true;
  }

  Future init() async {
    log('Initializing instance');

    await getlocation();

    await auth.load();

    if (dotenv.env['env'] == "development" && int.parse(dotenv.env['autolog']!) == 1) {
      await instance.auth.login(
          email: dotenv.env['autolog_email'].toString(),
          password: dotenv.env['autolog_password'].toString(),
          doSetup: true,
          remember: true);
    }
  }
}
