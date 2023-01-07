import 'package:carbon_icons/carbon_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
  DateFormat mapKey = DateFormat('yyyyMM');

  Map<int, double> spendingPerCategory = {}; // tagid to total spending
  double totalSpending = 0;
  int pieChartSelectIndex = -1;
  List<_ChartData> chart_data = [];

  @override
  void initState() {
    super.initState();
    createTagList();
    processNow();
  }

  void createTagList() {
    for (CategoryEntry entry in widget.datastore.categoryList) {
      tagMap[entry.id] = entry.caption;
    }
  }
  void processNow() {

    for (SpendingEntry entry in widget.monthlyList) {
      if (!entry.excludeFromSpending) {
        totalSpending += entry.value;
        double val = spendingPerCategory[entry.tagId] ?? 0;
        spendingPerCategory[entry.tagId] = val += entry.value;
      }
    }

    for (int i in spendingPerCategory.keys) {
      chart_data.add(_ChartData(tagMap[i]!, spendingPerCategory[i]!, ""));
    }
  }

    List<Color> generatePallete(int n) {
    List<Color> pallete = [];
    Color color = Color(0xFF82C3EC); // yellow

    for (int i = 0; i < n; i++) {
      HslColor hslColor = HslColor.fromColor(color);
      pallete.add(hslColor.rotateHue((360 / n * i) % 360).toColor());
    }
    return pallete;
  }

  Widget pieChartCategory() {
    if (chart_data.isEmpty) {
      return Container(child: Center(child: Text("No Data Found")));
    }
    return SfCircularChart(
        title: ChartTitle(text: "Spending Per Category"),
        palette: generatePallete(chart_data.length),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        series: <DoughnutSeries<_ChartData, String>>[
          DoughnutSeries<_ChartData, String>(
            explode: true,
            radius: "100",
            innerRadius: "45",
            dataSource: chart_data,
            xValueMapper: (_ChartData data, _) => data.xData,
            yValueMapper: (_ChartData data, _) => data.yData * -1,
            dataLabelMapper: (_ChartData data, _) => data.xData,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            onPointTap: (ChartPointDetails pointInteractionDetails) {
              print(pointInteractionDetails.pointIndex);
            },
          ),
        ]);
  }

  Widget barChartCategory() {
    if (chart_data.isEmpty) {
      return Container(child: Center(child: Text("No Data Found")));
    }

    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: (chart_data
                            .map((e) => e.yData / totalSpending * 10)
                            .toList()
                            .reduce(max) +
                        1)
                    .floor() *
                10,
            interval: 10),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
              dataSource: chart_data,
              xValueMapper: (_ChartData data, _) => data.xData,
              yValueMapper: (_ChartData data, _) =>
                  (data.yData) / totalSpending * 100,
              name: "Spending",
              color: Color.fromRGBO(8, 142, 255, 1))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.grey,
            body: SingleChildScrollView(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        64, // 64 = bottomnavbar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        barChartCategory(),
                        const Spacer(),
                      ],
                    )))));
  }
}

class _ChartData {
  _ChartData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  final String? text;
}
