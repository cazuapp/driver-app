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
import 'package:cazuapp/bloc/stats/bloc.dart';
import 'package:cazuapp/components/divisor.dart';
import 'package:cazuapp/components/etc.dart';
import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/indicator.dart';
import 'package:cazuapp/components/item_extended.dart';
import 'package:cazuapp/components/progress.dart';
import 'package:cazuapp/components/topbar.dart';
import 'package:cazuapp/components/utext.dart';
import 'package:cazuapp/core/theme.dart';
import 'package:cazuapp/models/driver_stats.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DriverStatsPage extends StatelessWidget {
  const DriverStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ServerInfoBloc(instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(SetDate(dateStart: Etc.getToday(), dateEnd: Etc.getToday()))
              ..add(const FetchDriverStats()))
      ],
      child: const StatsList(),
    );
  }
}

class PieChartStats extends StatefulWidget {
  const PieChartStats({super.key});

  @override
  State<StatefulWidget> createState() => ChartState();
}

class ChartState extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerInfoBloc, ServerInfoState>(builder: (context, state) {
      return Container(
          padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
          color: AppTheme.white,
          child: AspectRatio(
            aspectRatio: 1.7,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections(
                            state.driverStats.ok.toDouble(),
                            state.driverStats.cancelled.toDouble(),
                            state.driverStats.pending.toDouble(),
                            state.driverStats.nopayment.toDouble(),
                            state.driverStats.other.toDouble()),
                      ),
                    ),
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: AppTheme.lockeye2,
                      text: 'OK',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppTheme.alert,
                      text: 'Cancelled',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppTheme.lockeye,
                      text: 'Pending',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppTheme.black,
                      text: 'Other',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppTheme.secondary,
                      text: 'No Payment',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 18,
                ),
              ],
            ),
          ));
    });
  }

  List<PieChartSectionData> showingSections(
      double ok, double cancelled, double pending, double nopayment, double other) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppTheme.lockeye2,
            value: ok,
            title: '$ok%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppTheme.alert,
            value: cancelled,
            title: '$cancelled%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: AppTheme.lockeye,
            value: pending,
            title: '$pending%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: AppTheme.secondary,
            value: nopayment,
            title: '$nopayment%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: AppTheme.black,
            value: other,
            title: '$other%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class StatsList extends StatefulWidget {
  const StatsList({super.key});

  @override
  State<StatsList> createState() => _StatsList();
}

class _StatsList extends State<StatsList> {
  String _start = '';
  String _end = '';

  @override
  void initState() {
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _start = DateFormat('yyyy-MM-dd').format(args.value.startDate);
        _end = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate);
      }
    });

    context.read<ServerInfoBloc>().add(SetDate(dateStart: _start, dateEnd: _end));
    context.read<ServerInfoBloc>().add(const FetchDriverStats());
  }

  bool isBottom = false;
  bool displayCalendar = false;

  /* Toggler is in charge of displaying calendar when required */

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ServerInfoBloc, ServerInfoState>(
      builder: (context, state) {
        bool any = false;

        if (state.driverStats.ok > 0 ||
            state.driverStats.cancelled > 0 ||
            state.driverStats.nodriver > 0 ||
            state.driverStats.nopayment > 0 ||
            state.driverStats.other > 0 ||
            state.driverStats.pending > 0) {
          any = true;
        }
        switch (state.status) {
          case ServerInfoStatus.initial:
            return const Loader();
          case ServerInfoStatus.loading:
            return const Loader();
          case ServerInfoStatus.success:
            break;
          case ServerInfoStatus.failure:
            break;
          case ServerInfoStatus.empty:
            return const FailurePage(title: "Driver statistics", subtitle: "No rides found.");
        }

        return Scaffold(
            appBar: const TopBar(title: "Driver statistics"),
            backgroundColor: AppTheme.background,
            body: SafeArea(
                child: SizedBox(
                    height: size.height,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 20, left: 14),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                          ])),
                      displayCalendar
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: size.width * 0.03,
                                  bottom: size.height * 0.02,
                                  left: size.height * 0.02,
                                  right: size.height * 0.01),
                              child: SfDateRangePicker(
                                backgroundColor: AppTheme.white,
                                onSelectionChanged: _onSelectionChanged,
                                selectionMode: DateRangePickerSelectionMode.range,
                              ))
                          : const SizedBox.shrink(),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
                          child: state.dateStart != state.dateEnd
                              ? utext(title: "Date ${state.dateStart} - ${state.dateEnd}", fontWeight: FontWeight.w400)
                              : state.dateStart == Etc.getToday()
                                  ? utext(title: "Today's deliveries", fontWeight: FontWeight.w400)
                                  : utext(fontWeight: FontWeight.w400, title: "Date ${state.dateStart}")),
                      any ? ShowStats(stats: state.driverStats) : const StatsFailed(),
                    ])))));

        //)
      },
    );
  }
}

class StatsFailed extends StatelessWidget {
  const StatsFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 13, right: 13, top: 60),
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
                        const Icon(FontAwesomeIcons.circleExclamation, size: 49, color: AppTheme.alert),
                        const SizedBox(height: 35),
                        utext(
                            title: "No data found in range provided",
                            fontSize: 20,
                            color: AppTheme.main,
                            align: Alignment.center,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 15),
                        utext(
                            align: Alignment.center,
                            title: "Feel free to check different dates within the calendar",
                            textAlign: TextAlign.center,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(159, 18, 18, 18)),
                        const SizedBox(height: 25),
                      ]))
            ]));
  }
}

class ShowStats extends StatelessWidget {
  final DriverStats stats;
  const ShowStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 13, right: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const PieChartStats(),
            const SizedBox(height: 15),
            utext(title: "Stats ", fontWeight: FontWeight.w500),
            const SizedBox(height: 15),
            ItemExtended(input: "OK", iconsrc: FontAwesomeIcons.burger, title: stats.ok.toString()),
            const AppDivisor(top: 2),
            ItemExtended(input: "Cancelled", iconsrc: FontAwesomeIcons.xmark, title: stats.cancelled.toString()),
            const AppDivisor(top: 2),
            ItemExtended(input: "Pending", iconsrc: FontAwesomeIcons.motorcycle, title: stats.pending.toString()),
            const AppDivisor(top: 2),
            ItemExtended(input: "Other", iconsrc: FontAwesomeIcons.clipboardCheck, title: stats.other.toString()),
            const AppDivisor(top: 2),
            ItemExtended(input: "No Payment", iconsrc: FontAwesomeIcons.cashRegister, title: stats.nopayment.toString())
          ],
        ));
  }
}
