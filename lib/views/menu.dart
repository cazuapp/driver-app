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

import 'package:cazuapp/components/tabs.dart';
import 'package:cazuapp/views/account/account.dart';
import 'package:cazuapp/views/home/home.dart';
import 'package:cazuapp/views/menu_orders/homemenu.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MenuPage());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (bool didPop) {
          if (didPop) {
            if (Navigator.of(context).canPop()) {
              return;
              //Navigator.pop(context);
            } else {
              return;
            }
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MenuForm(),
        ));
  }
}

class MenuForm extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();

  MenuForm({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: const HomePage(),
          icon: const Icon(FontAwesomeIcons.house),
          title: 'Home',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const MenuOrdersPage(),
          icon: const Icon(FontAwesomeIcons.solidFolderOpen),
          title: 'History', /* History tab, which track all deliveries by user */
          //  navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: const AccountPage(),
          icon: const Icon(FontAwesomeIcons.gear),
          title: 'Account',
          //  navigatorkey: _tab4navigatorKey,
        ),
      ],
    );
  }
}
