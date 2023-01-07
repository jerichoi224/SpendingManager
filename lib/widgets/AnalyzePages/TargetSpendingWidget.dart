import 'package:carbon_icons/carbon_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TargetSpendingWidget extends StatefulWidget {
  late Datastore datastore;
  late List<SpendingEntry> monthlyList;

  TargetSpendingWidget(
      {Key? key, required this.datastore, required this.monthlyList})
      : super(key: key);

  @override
  State createState() => _TargetSpendingState();
}

class _TargetSpendingState extends State<TargetSpendingWidget> {
  Map<int, String> tagMap = {}; // tagid to string
  DateFormat mapKey = DateFormat('MM-dd');

  Map<int, dynamic> spendingPerDay = {}; // date -> [dailytotal, acctotal, day]
  double totalSpending = 0;
  int pieChartSelectIndex = -1;
  List<_TargetChartData> chartData = [];
  double dailyTarget = 20000;

  @override
  void initState() {
    super.initState();
    createTagList();
    processData();
  }

  void createTagList() {
    for (CategoryEntry entry in widget.datastore.categoryList) {
      tagMap[entry.id] = entry.caption;
    }
  }

  void processData() {
    widget.monthlyList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(widget.monthlyList[0].dateTime);
    int keyDate =
        DateTime(date.year, date.month, 1, 0, 0, 0).millisecondsSinceEpoch;
    chartData.clear();
    chartData.add(_TargetChartData(
        DateTime.fromMillisecondsSinceEpoch(keyDate), 0, 0, 0));

    for (SpendingEntry entry in widget.monthlyList) {
      if (!entry.excludeFromSpending) {
        date = DateTime.fromMillisecondsSinceEpoch(entry.dateTime);
        keyDate = DateTime(date.year, date.month, date.day, 23, 59)
            .millisecondsSinceEpoch;
        totalSpending += entry.value;
        List<dynamic> val = spendingPerDay[keyDate] ?? [0, 0, date.day];
        spendingPerDay[keyDate] = [
          val[0] += entry.value,
          totalSpending,
          date.day
        ];
      }
    }

    for (int i in spendingPerDay.keys.toList()) {
      List<dynamic> val = spendingPerDay[i];
      DateTime date = DateTime.fromMillisecondsSinceEpoch(i);
      chartData.add(_TargetChartData(
          date, val[0] * -1, val[1] * -1, date.day * dailyTarget));
    }
  }

  List<Widget> dailySpendingList() {
    if (chartData.isEmpty) {
      return [Container()];
    }

    List<Widget> returnList = [];

    for (_TargetChartData data in chartData) {
      if (data.date.hour != 0) {
        returnList.add(Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 20, 0),
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(mapKey.format(data.date),
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400))),
              Spacer(),
              Text(data.daily.toString(),
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400)))
            ],
          ),
        ));
      }
    }
    return returnList;
  }

  Widget lineChart() {
    if (chartData.isEmpty) {
      return Container(child: Center(child: Text("No Data Found")));
    }

    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: false),
        series: <LineSeries<_TargetChartData, DateTime>>[
          LineSeries<_TargetChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (_TargetChartData data, _) => data.date,
              yValueMapper: (_TargetChartData data, _) => data.accum,
              name: "Spending"),
          LineSeries<_TargetChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (_TargetChartData data, _) => data.date,
              yValueMapper: (_TargetChartData data, _) => data.target,
              name: "Target"),
        ]);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: chartData.isEmpty
                ? Container(child: Center(child: Text("No Data Found")))
                : Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text("Spending & Target",
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600))),
                            ),
                            const Spacer(),
                            Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    icon: const Icon(CarbonIcons.settings)))
                          ],
                        ),
                      ),
                      lineChart(),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: dailySpendingList(),
                              ),
                            )),
                      ),
                    ],
                  )));
  }
}

class _TargetChartData {
  _TargetChartData(this.date, this.daily, this.accum, this.target, [this.text]);

  final DateTime date;
  final num daily;
  final num accum;
  final num target;
  final String? text;
}
