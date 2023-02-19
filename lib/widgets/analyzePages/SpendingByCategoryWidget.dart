import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/colorGenerator.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/numberFormat.dart';
import 'package:spending_manager/widgets/components/viewPerCategoryPopup.dart';
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
  String locale = "en";
  String currency = "";

  Map<int, String> tagMap = {}; // tagid to string
  Map<int, double> spendingPerCategory = {}; // tag -> amount
  Map<int, double> spendingPerAccount = {}; // account -> amount
  Map<int, Map<int, double>> spendingByTagAccount =
  {}; // tag -> account -> spending
  Map<int, bool> accountUsed = {};
  Map<int, bool> categoryUsed = {};
  List<_ColumnChartData> columnChartData = [];
  List<ChartSeries> seriesData = [];

  double totalSpending = 0;
  int pieChartSelectIndex = -1;
  List<_PieChartData> pieChartData = [];
  late List<int> sortedKeys;
  bool showPieChart = true;

  @override
  void initState() {
    super.initState();
    locale = widget.datastore.getPref("locale") ?? "en";
    currency = widget.datastore.getPref("currency") ?? "KRW";

    if (widget.datastore.prefMap.keys.contains("show_pieChart")) {
      showPieChart = widget.datastore.getPref("show_pieChart");
    }
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
      spendingByTagAccount[c.id] = accForCategory;
    }

    for (SpendingEntry entry in widget.monthlyList) {
      if (!entry.excludeFromSpending) {
        totalSpending += entry.value;
        double pVal = spendingPerCategory[entry.tagId] ?? 0;
        spendingPerCategory[entry.tagId] = pVal += entry.value;

        double accVal = spendingPerAccount[entry.accId] ?? 0;
        spendingPerAccount[entry.accId] = accVal += entry.value * -1;

        double cVal = spendingByTagAccount[entry.tagId]![entry.accId] ?? 0;
        spendingByTagAccount[entry.tagId]![entry.accId] =
            cVal + entry.value * -1;
        categoryUsed[entry.tagId] = true;
        accountUsed[entry.accId] = true;
      }
    }

    sortedKeys = spendingPerCategory.keys.toList(growable: false)
      ..sort((k1, k2) =>
          spendingPerCategory[k1]!.compareTo(spendingPerCategory[k2]!));

    for (int i in sortedKeys) {
      pieChartData.add(_PieChartData(tagMap[i]!, spendingPerCategory[i]!, ""));
    }

    for (int tag in spendingByTagAccount.keys) {
      if (categoryUsed[tag] ?? false) {
        Map<int, double> spentByCat = {};
        for (AccountEntry acc in widget.datastore.accountList) {
          spentByCat[acc.id] = spendingByTagAccount[tag]![acc.id] ?? 0;
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
            dataLabelMapper: (_ColumnChartData data, _) =>
                data.yData[acc.id].toString(),
            yValueMapper: (_ColumnChartData data, _) => data.yData[acc.id]));
      }
    }
  }

  List<Widget> spendingByAccountList() {
    if (spendingPerAccount.isEmpty) {
      return [Container()];
    }

    List<Widget> returnList = [];

    for (int i in spendingPerAccount.keys) {
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
              const Spacer(),
              Text(
                  moneyFormat(
                      spendingPerAccount[i]!.toString(), currency, true),
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

  List<Widget> spendingByCategory() {
    if (spendingPerCategory.isEmpty) {
      return [Container()];
    }

    List<Widget> returnList = [];

    for (int i in sortedKeys) {
      returnList.add(InkWell(
          onTap: () {
            viewPerCategoryPopup(context, widget.datastore,
                widget.monthlyList.where((element) => element.tagId == i)
                    .toList(), tagMap[i]!);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 1, 20, 2),
            height: 40,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    "${tagMap[i]!} (${(spendingPerCategory[i]! / totalSpending *
                        100).round()}%)",
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400))),
                const Spacer(),
                Text(
                    moneyFormat((spendingPerCategory[i]! * -1).toString(),
                        currency, true),
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400)))
              ],
            ),
          )));
    }
    return returnList;
  }

  Widget pieChartCategory() {
    return SfCircularChart(
        palette: generatePallete(pieChartData.length),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <DoughnutSeries<_PieChartData, String>>[
          DoughnutSeries<_PieChartData, String>(
            explode: true,
            animationDuration: 650,
            radius: "100",
            innerRadius: "45",
            dataSource: pieChartData,
            xValueMapper: (_PieChartData data, _) => data.xData,
            yValueMapper: (_PieChartData data, _) => data.yData * -1,
            dataLabelMapper: (_PieChartData data, _) => data.xData,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: GoogleFonts.lato(
                    textStyle: const TextStyle(fontWeight: FontWeight.w400))),
          ),
        ]);
  }

  Widget barChartCategory() {
    if (pieChartData.isEmpty) {
      return Container(child: Center(child: Text("No Data Found")));
    }

    return SfCartesianChart(
      palette: generatePallete(widget.datastore.accountList.length),
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
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
            body: pieChartData.isEmpty
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
                        child: Text(
                            showPieChart
                                ? "Spending Per Category"
                                : "Spending Per Category/Account",
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
                                widget.datastore.setPref(
                                    "show_pieChart", !showPieChart);

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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: showPieChart
                              ? spendingByCategory()
                              : spendingByAccountList(),
                        ),
                      ),
                    ))
              ],
            )));
  }
}

class _PieChartData {
  _PieChartData(this.xData, this.yData, [this.text]);

  final String xData;
  final num yData;
  final String? text;
}

class _ColumnChartData {
  _ColumnChartData(this.xData, this.yData, [this.text]);

  final String xData;
  final Map<int, double> yData;
  final String? text;
}
