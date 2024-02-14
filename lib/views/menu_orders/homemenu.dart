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
import 'package:cazuapp/bloc/orders_menu/bloc.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/order_list_item.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/components/topbar.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MenuOrdersPage extends StatelessWidget {
  const MenuOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                OrdersMenuBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)..add(OrdersFetch()))
      ],
      child: const HomeMenuList(),
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

  List<String> ids = ['All', 'Pending', 'No driver', 'Cancelled', 'No payment', 'Other'];
  String? original = "All";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersMenuBloc, OrdersState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.only(top: 1, left: 10),
          child: DropdownButtonHideUnderline(
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
                    child: Text(
                      original!,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(15),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
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
                            fontSize: 15.0,
                            color: AppTheme.black,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: state.text,
              onChanged: (String? value) {
                setState(() {
                  original = value;
                });

                context.read<OrdersMenuBloc>().add(Init());

                if (value == "All") {
                  context.read<OrdersMenuBloc>().add(SetParam(param: Param.all, text: value!));
                } else if (value == "Cancelled") {
                  context.read<OrdersMenuBloc>().add(SetParam(param: Param.cancelled, text: value!));
                } else if (value == "No payment") {
                  context.read<OrdersMenuBloc>().add(SetParam(param: Param.nopayment, text: value!));
                } else if (value == "Pending") {
                  context.read<OrdersMenuBloc>().add(SetParam(param: Param.pending, text: value!));
                } else if (value == "No driver") {
                  context.read<OrdersMenuBloc>().add(SetParam(param: Param.nodriver, text: value!));
                } else if (value == "Other") {
                  context.read<OrdersMenuBloc>().add(SetParam(param: Param.other, text: value!));
                }
                context.read<OrdersMenuBloc>().add(OrdersFetch());
              },
              buttonStyleData: ButtonStyleData(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(190),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(14), right: ScreenUtil().setWidth(14)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: AppTheme.white,
                ),
                elevation: 2,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: AppTheme.black,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: ScreenUtil().setHeight(200),
                width: ScreenUtil().setWidth(190),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppTheme.white,
                ),
                offset: const Offset(0, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: ScreenUtil().setHeight(40),
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(14), right: ScreenUtil().setWidth(14)),
              ),
            ),
          ));
    });
  }
}

class HomeMenuList extends StatefulWidget {
  const HomeMenuList({super.key});

  @override
  State<HomeMenuList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeMenuList> {
  String _start = '';
  String _end = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _start = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        _end = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
      }
    });

    /* Resets orders from previous requests */

    context.read<OrdersMenuBloc>().add(Init());

    /* Sets new date */

    context.read<OrdersMenuBloc>().add(SetDate(dateStart: _start, dateEnd: _end));

    /* Fetch new batch of orders */

    context.read<OrdersMenuBloc>().add(OrdersFetch());
  }

  final _scrollController = ScrollController();

  bool isBottom = false;
  bool displayCalendar = false;

  /* Toggler is in charge of displaying calendar when required */

  void _toggle(bool sett) {
    setState(() {
      if (isBottom == sett) {
        displayCalendar = false;
        return;
      }
      isBottom = sett;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onHomeScroll);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<OrdersMenuBloc, OrdersState>(builder: (context, state) {
      switch (state.status) {
        case OrdersStatus.initial:
          return const Loader();
        case OrdersStatus.loading:
          return const Loader();
        case OrdersStatus.failure:
          return const FailurePage(title: "Orders list", subtitle: "Error loading orders");
        case OrdersStatus.success:
          return Scaffold(
              backgroundColor: AppTheme.white,
              appBar: const TopBar(title: "Orders list"),
              body: SafeArea(
                  child: Column(children: [
                displayCalendar
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: size.width * 0.03,
                            bottom: size.height * 0.02,
                            left: size.height * 0.01,
                            right: size.height * 0.01),
                        child: SfDateRangePicker(
                          backgroundColor: AppTheme.white,
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode: DateRangePickerSelectionMode.range,
                        ))
                    : const SizedBox.shrink(),
                Padding(
                    padding: EdgeInsets.only(
                        top: size.width * 0.05,
                        bottom: size.height * 0.0,
                        left: size.height * 0.01,
                        right: size.height * 0.03),
                    child: Column(children: <Widget>[
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        displayCalendar ? const SizedBox.shrink() : const DropDown(),
                        !displayCalendar
                            ? InkWell(
                                child: const Icon(FontAwesomeIcons.calendar),
                                onTap: () => {
                                      setState(
                                        () {
                                          displayCalendar = true;
                                        },
                                      )
                                    })
                            : const SizedBox.shrink(),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        !displayCalendar ? const SizedBox.shrink() : const DropDown(),
                        displayCalendar
                            ? InkWell(
                                child: const Icon(FontAwesomeIcons.calendar),
                                onTap: () => {
                                      setState(
                                        () {
                                          displayCalendar = false;
                                        },
                                      )
                                    })
                            : const SizedBox.shrink(),
                      ])
                    ])),
                const SizedBox(height: 2),
                Padding(
                    padding: EdgeInsets.only(
                        top: size.width * 0.01,
                        bottom: size.height * 0.01,
                        left: size.height * 0.03,
                        right: size.height * 0.03),
                    child: Column(children: <Widget>[
                      state.text != "All" ? utext(title: "Filter: ${state.text}") : const SizedBox.shrink(),
                      state.dateStart.isNotEmpty && state.dateEnd.isNotEmpty
                          ? utext(title: "Date ${state.dateStart} - ${state.dateEnd}")
                          : const SizedBox.shrink(),
                    ])),
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
                                  : OrderListItem(order: state.orders[index], current: state.orders[index].orderStatus),
                            ]);
                          },
                          itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
                          controller: _scrollController,
                        )))
              ])));
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onHomeScroll)
      ..dispose();
    super.dispose();
  }

  void _onHomeScroll() {
    if (_isBottom) {
      /* Scroll more items on request */
      context.read<OrdersMenuBloc>().add(OnHomeScroll());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if (currentScroll <= 0.9) {
      _toggle(false);
    } else {
      _toggle(true);
    }
    return currentScroll >= (maxScroll * 0.9);
  }
}
