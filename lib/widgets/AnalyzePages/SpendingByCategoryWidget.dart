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

class SpendingByCategoryWidget extends StatefulWidget {
  late Datastore datastore;
  late List<SpendingEntry> monthlyList;

  SpendingByCategoryWidget(
      {Key? key, required this.datastore, required this.monthlyList})
      : super(key: key);

  @override
  State createState() => _SpendingByCategoryState();
}

class _SpendingByCategoryState extends State<SpendingByCategoryWidget> {
  Map<int, String> tagMap = {}; // tagid to string
  Map<int, double> spendingPerCategory = {}; // tagid to total spending
  double totalSpending = 0;
  int pieChartSelectIndex = -1;
  List<_ChartData> chartData = [];
  late List<int> sortedKeys;
  bool showPieChart = true;

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
    for (SpendingEntry entry in widget.monthlyList) {
      if (!entry.excludeFromSpending) {
        totalSpending += entry.value;
        double val = spendingPerCategory[entry.tagId] ?? 0;
        spendingPerCategory[entry.tagId] = val += entry.value;
      }
    }

    sortedKeys = spendingPerCategory.keys.toList(growable: false)
      ..sort((k1, k2) =>
          spendingPerCategory[k1]!.compareTo(spendingPerCategory[k2]!));

    for (int i in sortedKeys) {
      chartData.add(_ChartData(tagMap[i]!, spendingPerCategory[i]!, ""));
    }
  }

  List<Widget> spendingHistory() {
    if (spendingPerCategory.isEmpty) {
      return [Container()];
    }

    List<Widget> returnList = [];

    for (int i in sortedKeys) {
      returnList.add(Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 20, 0),
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                "${tagMap[i]!} (${(spendingPerCategory[i]! / totalSpending * 100).round()}%)",
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400))),
            Spacer(),
            Text((spendingPerCategory[i]! * -1).toString(),
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400)))
          ],
        ),
      ));
    }
    return returnList;
  }

  List<Color> generatePallete(int n) {
    List<Color> pallete = [];
    Color color = Colors.blue.shade200;
    for (int i = 0; i < n; i++) {
      HslColor hslColor = HslColor.fromColor(color);
      pallete.add(hslColor.rotateHue((360 / n * i) % 360).toColor());
    }
    return pallete;
  }

  Widget pieChartCategory() {
    return SfCircularChart(
        palette: generatePallete(chartData.length),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        series: <DoughnutSeries<_ChartData, String>>[
          DoughnutSeries<_ChartData, String>(
            explode: true,
            radius: "100",
            innerRadius: "45",
            dataSource: chartData,
            xValueMapper: (_ChartData data, _) => data.xData,
            yValueMapper: (_ChartData data, _) => data.yData * -1,
            dataLabelMapper: (_ChartData data, _) => data.xData,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(fontWeight: FontWeight.w400))),
            onPointTap: (ChartPointDetails pointInteractionDetails) {
              print(pointInteractionDetails.pointIndex);
            },
          ),
        ]);
  }

  Widget barChartCategory() {
    if (chartData.isEmpty) {
      return Container(child: Center(child: Text("No Data Found")));
    }

    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
            labelStyle: GoogleFonts.lato(
                textStyle: const TextStyle(fontWeight: FontWeight.w700))),
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: (chartData
                            .map((e) => e.yData / totalSpending * 10)
                            .toList()
                            .reduce(max) +
                        1)
                    .floor() *
                10,
            interval: 10),
        tooltipBehavior: TooltipBehavior(enable: false),
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.xData,
              yValueMapper: (_ChartData data, _) =>
                  (data.yData) / totalSpending * 100,
              name: "Spending",
              color: Colors.blue.shade300)
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
                              child: Text("Spending Per Category",
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
                                      setState(() {
                                        showPieChart = !showPieChart;
                                      });
                                    },
                                    icon: Icon(showPieChart
                                        ? CarbonIcons.chart_bar
                                        : CarbonIcons.chart_pie)))
                          ],
                        ),
                      ),
                      showPieChart ? pieChartCategory() : barChartCategory(),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child:Container(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: spendingHistory(),
                              ),
                            ),
                          ),
                        )
                      )
                    ],
                  )));
  }
}

class _ChartData {
  _ChartData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  final String? text;
}
