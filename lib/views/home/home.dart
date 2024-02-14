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
import 'package:cazuapp/components/appear.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/views/home/home_list_item.dart';
import 'package:cazuapp/views/home/search.dart';
import 'package:cazuapp/views/home/search_results.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /* We retrieve home items on page opening */
        BlocProvider(
            create: (_) => HomeBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(HomeFetch()))
      ],
      child: const HomeList(),
    );
  }
}

class DropDown extends StatefulWidget {
  const DropDown({super.key});

  @override
  State<DropDown> createState() => DropDownState();
}

class DropDownState extends State<DropDown> {
  String? selectedValue;

  List<String> ids = ['All Pending', 'Assigned to me'];
  String? original = "All Pending";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(
                Icons.list,
                size: ScreenUtil().setSp(16),
                color: AppTheme.black,
              ),
              SizedBox(
                width: ScreenUtil().setWidth(4),
              ),
              Expanded(
                child: utext(
                  title: original!,
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: ids
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.ubuntu(
                        fontSize: ScreenUtil().setSp(15),
                        color: AppTheme.black,
                        fontWeight: FontWeight.w300,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: state.param == Param.all ? "All Pending" : "Assigned to me",
          onChanged: (String? value) {
            setState(() {
              original = value;
            });

            context.read<HomeBloc>().add(Init());

            if (value == "All Pending") {
              context.read<HomeBloc>().add(SetParam(param: Param.all));
            } else {
              context.read<HomeBloc>().add(SetParam(param: Param.mine));
            }

            context.read<HomeBloc>().add(HomeFetch());
          },
          buttonStyleData: ButtonStyleData(
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setWidth(190),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(14), right: ScreenUtil().setWidth(14)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(4)),
              border: Border.all(
                color: Colors.black26,
              ),
              color: AppTheme.white,
            ),
            elevation: 2,
          ),
          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: ScreenUtil().setSp(14),
            iconEnabledColor: AppTheme.black,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: ScreenUtil().setHeight(200),
            width: ScreenUtil().setWidth(190),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(4)),
              color: AppTheme.white,
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(ScreenUtil().setWidth(40)),
              thickness: MaterialStateProperty.all<double>(ScreenUtil().setWidth(6)),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: ScreenUtil().setHeight(40),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(14), right: ScreenUtil().setWidth(14)),
          ),
        ),
      );
    });
  }
}

class HomeList extends StatefulWidget {
  const HomeList({super.key});

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      /* Sets variable amIAvailable to see if driver is ready to take orders */

      bool amIAvailable = context.select((AuthenticationBloc bloc) => bloc.instance.auth.available);

      if (!amIAvailable) {
        return const FailurePage(
            title: "Orders list",
            subtitle: "You are not available",
            fawesome: FontAwesomeIcons.carBurst,
            color: AppTheme.subprimarycolordeco);
      }

      switch (state.status) {
        case HomeStatus.initial:
          return const Loader();

        case HomeStatus.loading:
          return const Loader();
        case HomeStatus.failure:
          return const FailurePage(title: "Orders list", subtitle: "Error loading orders");
        case HomeStatus.success:
          return Scaffold(
              floatingActionButton: state.param == Param.all
                  ? FloatingActionButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      elevation: 6.0, // Set the desired shadow elevation
                      backgroundColor: AppTheme.shallowlockeye,
                      onPressed: () {
                        context.read<HomeBloc>().add(Init());
                        context.read<HomeBloc>().add(HomeFetch());
                      },
                      child: const Icon(Icons.refresh, color: AppTheme.white),
                    )
                  : null,
              appBar: null,
              backgroundColor: AppTheme.white,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  child: SafeArea(
                      child: SizedBox(
                          height: size.height,
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 10),
                                child: Container(
                                    height: size.height / 16,
                                    width: size.width * 0.90,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    /* Search button widget */
                                    child: HomeSearchBar(
                                        title: state.text.isEmpty ? "Search" : "",
                                        onTap: () => {appear(context, const SearchPage())}))),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.02,
                                  bottom: size.height * 0.02,
                                  left: size.width * 0.04,
                                  right: size.width * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      DropDown(),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  utext(
                                    title: "${state.total.toString()} in total",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: _scrollController,
                                    thickness: 7,
                                    child: ListView.builder(
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(children: <Widget>[
                                          index >= state.orders.length
                                              ? const SizedBox.shrink()
                                              : HomeListItem(
                                                  order: state.orders[index], current: state.orders[index].orderStatus),
                                        ]);
                                      },
                                      itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
                                      controller: _scrollController,
                                    )))
                          ])))));
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeBloc>().add(HomeFetch());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }
}
