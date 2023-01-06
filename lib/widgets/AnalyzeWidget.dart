import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyzeWidget extends StatefulWidget {
  late Datastore datastore;

  AnalyzeWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _AnalyzeState();
}

class _AnalyzeState extends State<AnalyzeWidget> {
  DateTime datetime = DateTime.now();
  Map<String, dynamic> monthlyData = {};
  Map<int, String> tagMap = {}; // tagid to string
  List<SpendingEntry> spendingList = [];
  DateFormat mapKey = DateFormat('yyyyMM');

  Map<int, double> spendingPerCategory = {}; // tagid to total spending
  double totalSpending = 0;
  List<PieChartSectionData> SpendingPieData = [];
  int pieChartSelectIndex = -1;
  List<_PieData> pie_data = [];

  @override
  void initState() {
    super.initState();
    createTagList();
    processNow();
    spendingList = widget.datastore.spendingList;
    spendingList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  void createTagList() {
    for (CategoryEntry entry in widget.datastore.categoryList) {
      tagMap[entry.id] = entry.caption;
    }
  }

  void processNow() {
    DateTime start = DateTime(datetime.year, datetime.month, 1);
    DateTime end = (datetime.month < 12)
        ? DateTime(datetime.year, datetime.month + 1, 1)
        : DateTime(datetime.year + 1, 1, 1);

    List<SpendingEntry> currentList = widget.datastore.spendingList
        .where((element) =>
            element.dateTime >= start.millisecondsSinceEpoch &&
            element.dateTime < end.millisecondsSinceEpoch)
        .toList();

    spendingPerCategory.clear();
    pie_data.clear();
    totalSpending = 0;

    for (SpendingEntry entry in currentList) {
      if (!entry.excludeFromSpending) {
        totalSpending += entry.value;
        double val = spendingPerCategory[entry.tagId] ?? 0;
        spendingPerCategory[entry.tagId] = val += entry.value;
      }
    }

    for (int i in spendingPerCategory.keys) {
      pie_data.add(_PieData(tagMap[i]!, spendingPerCategory[i]!, ""));
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
    if (pie_data.isEmpty) {
      return Container(child: Center(child: Text("No Data Found")));
    }
    return SfCircularChart(
        title: ChartTitle(text: "Spending Per Category"),
        palette: generatePallete(pie_data.length),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        series: <PieSeries<_PieData, String>>[
          PieSeries<_PieData, String>(
            explode: true,
            radius: "100",
            dataSource: pie_data,
            xValueMapper: (_PieData data, _) => data.xData,
            yValueMapper: (_PieData data, _) => data.yData,
            dataLabelMapper: (_PieData data, _) => data.xData,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            onPointTap: (ChartPointDetails pointInteractionDetails) {
              print(pointInteractionDetails.pointIndex);
            },
          ),
        ]);
  }

  Widget monthSelector() {
    return SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      datetime = DateTime(datetime.year, datetime.month - 1, datetime.day);
                      processNow();
                      setState(() {
                      });
                    }, icon: Icon(CarbonIcons.chevron_left)),
                Column(
                  children: [
                    Text(
                      datetime.month.toString(),
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      datetime.year.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      datetime = DateTime(datetime.year, datetime.month + 1, datetime.day);
                      processNow();
                      setState(() {
                      });
                    }, icon: Icon(CarbonIcons.chevron_right))
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        64, // 64 = bottomnavbar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).viewPadding.top + 20,
                        ),
                        monthSelector(),
//                        const Spacer(),
                        pieChartCategory(),
                      ],
                    )))));
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  final String? text;
}
