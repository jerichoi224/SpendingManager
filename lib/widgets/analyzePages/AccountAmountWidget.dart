import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/colorGenerator.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/enum.dart';
import 'package:spending_manager/util/numberFormat.dart';
import 'package:spending_manager/widgets/components/tableCells.dart';
import 'package:spending_manager/widgets/components/viewAccountSpendingPopup.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AccountAmountWidget extends StatefulWidget {
  late Datastore datastore;
  late List<SpendingEntry> monthlyList;

  AccountAmountWidget(
      {Key? key, required this.datastore, required this.monthlyList})
      : super(key: key);

  @override
  State createState() => _AccountAmountState();
}

class _AccountAmountState extends State<AccountAmountWidget> {
  String locale = "";
  String currency = "";

  Map<int, dynamic> spendingPerAccount = {}; // accountId -> [spent, income]
  List<_AveragAccountData> chartData = [];

  @override
  void initState() {
    super.initState();
    locale = widget.datastore.getPref("locale") ?? "en";
    currency = widget.datastore.getPref("currency") ?? "KRW";

    processData();
  }

  Widget accountText(String text) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        height: 50,
        child: Text(text,
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700))));
  }

  amountTextStyle() {
    return GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400));
  }

  Widget amountText(num spent, num income) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 20, 5),
      child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          border: TableBorder.symmetric(
            outside: BorderSide.none,
          ),
          children: [
            TableRow(children: [
              cellContentText(
                  "+${moneyFormat(income.toString(), currency, true)}",
                  Alignment.centerRight, 25),
              cellContentText(
                  "${moneyFormat(spent.toString(), currency, true)}",
                  Alignment.centerRight, 25),
              cellContentText(
                  "${moneyFormat((income + spent).toString(), currency, true)}",
                  Alignment.centerRight, 25),
            ])
          ]),
    );
  }

  void processData() {
    if (widget.monthlyList.isEmpty) {
      return;
    }

    chartData.clear();
    spendingPerAccount.clear();

    for (SpendingEntry entry in widget.monthlyList) {
      if (entry.itemType == ItemType.expense.intVal) {
        List<dynamic> val = spendingPerAccount[entry.accId] ?? [0, 0];
        spendingPerAccount[entry.accId] = [val[0] + entry.value, val[1]];
      } else if (entry.itemType == ItemType.income.intVal) {
        List<dynamic> val = spendingPerAccount[entry.accId] ?? [0, 0];
        spendingPerAccount[entry.accId] = [val[0], val[1] + entry.value];
      } else {
        List<dynamic> val = spendingPerAccount[entry.accId] ?? [0, 0];
        spendingPerAccount[entry.accId] = [val[0] + entry.value, val[1]];
        val = spendingPerAccount[entry.recAccId] ?? [0, 0];
        spendingPerAccount[entry.recAccId] = [val[0], val[1] + entry.value];
      }
    }

    for (int i in spendingPerAccount.keys.toList()) {
      chartData.add(_AveragAccountData(
          i, spendingPerAccount[i][0], spendingPerAccount[i][1]));
    }
  }

  List<Widget> accountAmountList() {
    if (chartData.isEmpty) {
      return [];
    }

    List<Widget> returnList = [];

    for (_AveragAccountData data in chartData) {
      returnList.add(InkWell(
        onTap: () {
          viewAccountSpendingPopup(
              context,
              widget.datastore,
              widget.monthlyList
                  .where((element) => element.accId == data.accId)
                  .toList(),
              widget.datastore.accountList
                  .firstWhere((element) => element.id == data.accId)
                  .caption);
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              accountText(widget.datastore.accountList
                  .firstWhere((element) => element.id == data.accId)
                  .caption),
              amountText(data.spent, data.income)
            ],
          ),
        ),
      ));
    }

    return returnList;
  }

  Widget amountBarChart() {
    if (chartData.isEmpty) {
      return const Center(child: Text("No Data Found"));
    }

    List<Color> colors = generatePallete(5);

    colors.removeAt(1);
    return SfCartesianChart(
        palette: colors,
        primaryXAxis: CategoryAxis(),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <XyDataSeries<_AveragAccountData, String>>[
          ColumnSeries<_AveragAccountData, String>(
              dataSource: chartData,
              animationDuration: 650,
              xValueMapper: (_AveragAccountData data, _) => widget
                  .datastore.accountList
                  .firstWhere((element) => element.id == data.accId)
                  .caption,
              yValueMapper: (_AveragAccountData data, _) => data.spent * -1,
              name: "Spent"),
          ColumnSeries<_AveragAccountData, String>(
              dataSource: chartData,
              animationDuration: 650,
              xValueMapper: (_AveragAccountData data, _) => widget
                  .datastore.accountList
                  .firstWhere((element) => element.id == data.accId)
                  .caption,
              yValueMapper: (_AveragAccountData data, _) => data.income,
              name: "Income"),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: chartData.isEmpty
                ? const Center(child: Text("No Data Found"))
                : Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text("Accounts Balance",
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600))),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      amountBarChart(),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: Column(children: accountAmountList()))),
                      ),
                    ],
                  )));
  }
}

class _AveragAccountData {
  _AveragAccountData(this.accId, this.spent, this.income);

  final int accId;
  final num spent;
  final num income;
}
