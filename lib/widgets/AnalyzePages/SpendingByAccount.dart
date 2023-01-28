import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpendingByAccountWidget extends StatefulWidget {
  late Datastore datastore;
  late List<SpendingEntry> monthlyList;

  SpendingByAccountWidget(
      {Key? key, required this.datastore, required this.monthlyList})
      : super(key: key);

  @override
  State createState() => _SpendingByAccountState();
}

class _SpendingByAccountState extends State<SpendingByAccountWidget> {
  Map<int, String> tagMap = {}; // tagid to string
  Map<int, Map<int, double>> spendingByAccount = {}; // tagid to total spending
  Map<int, bool> accountUsed = {};
  Map<int, bool> categoryUsed = {};
  double totalSpending = 0;
  int pieChartSelectIndex = -1;
  List<_ColumnChartData> columnChartData = [];
  List<ChartSeries> seriesData = [];
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
    if (widget.monthlyList.isEmpty) {
      return;
    }

    for (CategoryEntry c in widget.datastore.categoryList) {
      Map<int, double> accForCategory = {};
      for (AccountEntry acc in widget.datastore.accountList) {
        accForCategory[acc.id] = 0;
      }
      spendingByAccount[c.id] = accForCategory;
    }

    for (SpendingEntry entry in widget.monthlyList) {
      if (!entry.excludeFromSpending) {
        double val = spendingByAccount[entry.tagId]![entry.accId] ?? 0;
        spendingByAccount[entry.tagId]![entry.accId] = val + entry.value * -1;
        categoryUsed[entry.tagId] = true;
        accountUsed[entry.accId] = true;
      }
    }

    for (int tag in spendingByAccount.keys) {
      if (categoryUsed[tag] ?? false) {
        Map<int, double> spentByCat = {};
        for (AccountEntry acc in widget.datastore.accountList) {
          spentByCat[acc.id] = spendingByAccount[tag]![acc.id] ?? 0;
        }
        columnChartData.add(_ColumnChartData(
            widget.datastore.categoryList
                .firstWhere((element) => element.id == tag)
                .caption,
            spentByCat));
      }
    }

    for (AccountEntry acc in widget.datastore.accountList) {
      if (true && (accountUsed[acc.id] ?? false)) {
        seriesData.add(ColumnSeries<_ColumnChartData, String>(
            animationDuration: 650,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            dataSource: columnChartData,
            name: acc.caption,
            xValueMapper: (_ColumnChartData data, _) => data.xData,
            yValueMapper: (_ColumnChartData data, _) => data.yData[acc.id]));
      }
    }
  }

  List<Widget> spendingByAccountList() {
    if (spendingByAccount.isEmpty) {
      return [Container()];
    }

    List<Widget> returnList = [];

    for (int i in spendingByAccount.keys) {
      if (accountUsed[i] ?? false) {
        returnList.add(Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 20, 0),
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  widget.datastore.accountList
                      .firstWhere((element) => element.id == i)
                      .caption,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400))),
              Spacer(),
              Text(
                  spendingByAccount[i]!
                      .values
                      .reduce((sum, value) => sum + value)
                      .toString(),
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

  Widget stackedBarChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: seriesData,
      legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: columnChartData.isEmpty
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
                              child: Text("Spending Per Account",
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600))),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      stackedBarChart(),
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
                                children: spendingByAccountList(),
                              ),
                            )),
                      ),
                    ],
                  )));
  }
}

class _ColumnChartData {
  _ColumnChartData(this.xData, this.yData, [this.text]);

  final String xData;
  final Map<int, double> yData;
  final String? text;
}
