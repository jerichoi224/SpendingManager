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
  List<_ChartData> chartData = [];
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

    for (AccountEntry acc in widget.datastore.accountList) {
      Map<int, double> categoryForAcc = {};
      for (CategoryEntry c in widget.datastore.categoryList) {
        categoryForAcc[c.id] = 0;
      }
      spendingByAccount[acc.id] = categoryForAcc;
    }

    for (SpendingEntry entry in widget.monthlyList) {
      if (!entry.excludeFromSpending) {
        double val = spendingByAccount[entry.accId]![entry.tagId] ?? 0;
        spendingByAccount[entry.accId]![entry.tagId] = val + entry.value * -1;
        categoryUsed[entry.tagId] = true;
        accountUsed[entry.accId] = true;
      }
    }

    for (int acc in spendingByAccount.keys) {
      if (accountUsed[acc] ?? false) {
        Map<int, double> spentByCat = {};
        for (CategoryEntry c in widget.datastore.categoryList) {
          spentByCat[c.id] = spendingByAccount[acc]![c.id] ?? 0;
//          print("$acc, ${c.id}, ${c.caption}, ${spentByCat[c.id]}");

        }
        chartData.add(_ChartData(
            widget.datastore.accountList
                .firstWhere((element) => element.id == acc)
                .caption,
            spentByCat));
      }
    }

    for (CategoryEntry c in widget.datastore.categoryList) {
      if (true) {
        //(categoryUsed[c.id] ?? false) {
        seriesData.add(StackedColumnSeries<_ChartData, String>(
            dataSource: chartData,
            name: c.caption,
            xValueMapper: (_ChartData data, _) => data.xData,
            yValueMapper: (_ChartData data, _) => data.yData[c.id]));
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

class _ChartData {
  _ChartData(this.xData, this.yData, [this.text]);

  final String xData;
  final Map<int, double> yData;
  final String? text;
}
