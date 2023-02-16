import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/colorGenerator.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/numberFormat.dart';
import 'package:spending_manager/widgets/components/tableCells.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AverageSpendingWidget extends StatefulWidget {
  late Datastore datastore;
  late List<SpendingEntry> monthlyList;

  AverageSpendingWidget(
      {Key? key, required this.datastore, required this.monthlyList})
      : super(key: key);

  @override
  State createState() => _AverageSpendingState();
}

class _AverageSpendingState extends State<AverageSpendingWidget> {
  DateFormat mapKey = DateFormat('MM-dd');
  String locale = "";
  String currency = "";

  Map<int, dynamic> spendingPerDay = {}; // date -> [dailytotal, acctotal, day]
  double totalSpending = 0;
  List<_AverageChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    locale = widget.datastore.getPref("locale") ?? "en";
    currency = widget.datastore.getPref("currency") ?? "KRW";

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

    bool hasFirstDay = false;
    bool hasToday = false;

    for (SpendingEntry entry in widget.monthlyList) {
      if (!entry.excludeFromSpending) {
        date = DateTime.fromMillisecondsSinceEpoch(entry.dateTime);

        hasFirstDay |= date.day == 1;
        hasToday |= date.day == DateTime.now().day;

        int keyDate = DateTime(date.year, date.month, date.day, 0, 0, 1)
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

    if(!hasFirstDay){
      int firstDate =
          DateTime(date.year, date.month, 1, 0, 0, 0).millisecondsSinceEpoch;
      chartData.add(
          _AverageChartData(DateTime.fromMillisecondsSinceEpoch(firstDate), 0, 0));
    }

    for (int i in spendingPerDay.keys.toList()) {
      List<dynamic> val = spendingPerDay[i];
      DateTime date = DateTime.fromMillisecondsSinceEpoch(i);
      chartData
          .add(_AverageChartData(date, val[0] * -1, (val[1] * -1) / date.day));
    }

    if (!hasToday) {
      DateTime today = DateTime.now();
      _AverageChartData last = chartData[chartData.length-1];
      chartData.add(_AverageChartData(
          DateTime(today.year, today.month, today.day, 0, 0, 0),
          0,
          (last.avg * last.date.day)/ today.day));
    }
  }

  List<TableRow> dailySpendingList() {
    if (chartData.isEmpty) {
      return [];
    }

    List<TableRow> returnList = [];

    for (_AverageChartData data in chartData) {
      if (data.date.second != 0) {
        returnList.add(TableRow(children: [
          cellContentText(mapKey.format(data.date), Alignment.centerLeft),
          cellContentText(moneyFormat(data.daily.toString(), currency, true),
              Alignment.centerRight),
          cellContentText(moneyFormat(data.avg.toString(), currency, true),
              Alignment.centerRight),
        ]));
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
        series: <XyDataSeries<_AverageChartData, DateTime>>[
          ColumnSeries<_AverageChartData, DateTime>(
              dataSource: chartData,
              animationDuration: 650,
              xValueMapper: (_AverageChartData data, _) => data.date,
              yValueMapper: (_AverageChartData data, _) => data.daily,
              name: "Daily"),
          LineSeries<_AverageChartData, DateTime>(
              dataSource: chartData,
              animationDuration: 650,
              xValueMapper: (_AverageChartData data, _) => data.date,
              yValueMapper: (_AverageChartData data, _) => data.avg,
              markerSettings: MarkerSettings(isVisible: true),
              name: "Average"),
        ]);
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
                              child: Text("Daily & Average Spending",
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600))),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      lineChart(),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        height: 40,
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(4),
                          },
                          border: TableBorder.symmetric(
                            outside: BorderSide.none,
                          ),
                          children: [
                            TableRow(children: [
                              cellTitleText("Date", Alignment.centerLeft),
                              cellTitleText(
                                  "Daily Spent", Alignment.centerRight),
                              cellTitleText(
                                  "Daily Average", Alignment.centerRight),
                            ]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(4),
                                      2: FlexColumnWidth(4),
                                    },
                                    border: TableBorder.symmetric(
                                      outside: BorderSide.none,
                                    ),
                                    children: dailySpendingList(),
                                  ),
                                ))),
                      ),
                    ],
                  )));
  }
}

class _AverageChartData {
  _AverageChartData(this.date, this.daily, this.avg, [this.text]);

  final DateTime date;
  final num daily;
  final num avg;
  final String? text;
}
