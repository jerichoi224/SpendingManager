import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/main.dart';
import 'package:spending_manager/util/colorGenerator.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/numberFormat.dart';
import 'package:spending_manager/widgets/components/spendingTargetDialog.dart';
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
  DateFormat mapKey = DateFormat('MM-dd');
  String locale = "ko_KR";

  Map<int, dynamic> spendingPerDay = {}; // date -> [dailytotal, acctotal, day]
  double totalSpending = 0;
  List<_TargetChartData> chartData = [];
  double dailyTarget = 0;

  @override
  void initState() {
    super.initState();
    dailyTarget = datastore.getPref("daily_target") ?? 0;
    processData();
  }

  void processData() {
    if (widget.monthlyList.isEmpty) {
      return;
    }

    chartData.clear();
    spendingPerDay.clear();

    widget.monthlyList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(widget.monthlyList[0].dateTime);
    int keyDate =
        DateTime(date.year, date.month, 1, 0, 0, 0).millisecondsSinceEpoch;
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
      return [];
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
              const Spacer(),
              Text(moneyFormat(data.daily.toString(), locale, true),
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400))),
              const Spacer(),
              Text(moneyFormat(data.accum.toString(), locale, true),
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400))),
            ],
          ),
        ));
      }
    }

    return returnList;
  }

  Widget lineChart() {
    if (chartData.isEmpty) {
      return const Center(child: Text("No Data Found"));
    }
    List<Color> colors = generatePallete(5);

    colors.removeAt(1);
    return SfCartesianChart(
        palette: colors,
        primaryXAxis: DateTimeAxis(),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <LineSeries<_TargetChartData, DateTime>>[
          LineSeries<_TargetChartData, DateTime>(
              dataSource: chartData,
              animationDuration: 650,
              xValueMapper: (_TargetChartData data, _) => data.date,
              yValueMapper: (_TargetChartData data, _) => data.accum,
              markerSettings: MarkerSettings(isVisible: true),
              name: "Spending"),
          LineSeries<_TargetChartData, DateTime>(
              dataSource: chartData,
              animationDuration: 650,
              xValueMapper: (_TargetChartData data, _) => data.date,
              yValueMapper: (_TargetChartData data, _) => data.target,
              name: "Target"),
        ]);
  }

  void openSetTarget(BuildContext context) async {
    final result = await spendingTargetDialog(context, datastore);
    if (result.runtimeType == bool && result) {
      dailyTarget = datastore.getPref("daily_target") ?? 0;
    }
  }

  @override
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
                                      openSetTarget(context);
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                        CarbonIcons.settings_adjust)))
                          ],
                        ),
                      ),
                      lineChart(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Date",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700))),
                            const Spacer(),
                            Text("Daily Spent",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700))),
                            const Spacer(),
                            Text("Accumulative",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)))
                          ],
                        ),
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