import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/enum.dart';
import 'package:spending_manager/util/numberFormat.dart';

Map<int, Color> itemTypeColor = {
  ItemType.income.intVal: Colors.blue,
  ItemType.expense.intVal: Colors.black,
};

Widget moneyText(SpendingEntry item, bool receiveAcc, String currency) {
  double amount = item.value;
  if (receiveAcc) {
    amount *= -1;
  }

  bool excluded = (amount < 0 && item.excludeFromSpending) ||
      (amount > 0 && item.excludeFromIncome);

  String text = amount.toString();
  if (amount > 0) {
    text = "+$text";
  }

  return Text(
    moneyFormat(text, currency, true),
    style: GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: 16,
            color: excluded ? Colors.black45 : itemTypeColor[item.itemType],
            fontWeight: FontWeight.w500)),
  );
}

Future<dynamic> viewPerCategoryPopup(BuildContext context,
    Datastore datastore,
    List<SpendingEntry> entryList,
    String tagName) async {
  String locale = datastore.getPref("locale") ?? "en";
  String currency = datastore.getPref("currency") ?? "KRW";

  bool useDecimal = usesDecimal(currency);

  List<Widget> accountSpending = [];

  double dayExpense = 0;
  double dayIncome = 0;
  int dailyCount = 0;
  double minHeight = 35;
  List<SpendingEntry> tmpList = [];

  entryList.sort((a, b) => a.dateTime.compareTo(b.dateTime));

  DateTime currentDate =
  DateTime.fromMillisecondsSinceEpoch(entryList[0].dateTime);
  String currentDay = DateFormat('yyyy-MM-dd').format(currentDate);
  SpendingEntry entry = entryList[0];
  for (int i = 0; i <= entryList.length; i++) {
    if (i != entryList.length) {
      entry = entryList[i];
    }
    DateTime entryDate = DateTime.fromMillisecondsSinceEpoch(entry.dateTime);
    String entryDay = DateFormat('yyyy-MM-dd').format(entryDate);
    if (entryDay != currentDay || i == entryList.length) {
      minHeight += 40;
      accountSpending.add(Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('MMM d').format(currentDate),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            dailyCount > 1
                ? Text(
              moneyFormat(
                  (dayExpense + dayIncome).toString(), currency, true),
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: itemTypeColor[dayExpense + dayIncome > 0
                        ? ItemType.income.intVal
                        : ItemType.expense.intVal],
                  )),
            )
                : Container(),
          ],
        ),
      ));

      for (SpendingEntry item in tmpList) {
        if (item.itemType == ItemType.transfer.intVal) // Receive Entry
            {
          minHeight += 30;
          accountSpending.add(Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.caption,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ),
                  const Spacer(),
                  moneyText(item, true, currency)
                ],
              )));
        }
        minHeight += 30;
        accountSpending.add(Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.caption,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 16,
                        )),
                  ),
                ),
                moneyText(item, false, currency)
              ],
            )));
      }

      currentDay = entryDay;
      currentDate = entryDate;
      tmpList.clear();
      dayExpense = 0;
      dayIncome = 0;
      dailyCount = 0;
    }

    if (entry.itemType == ItemType.expense.intVal) {
      dayExpense += entry.value;
      dailyCount++;
    }
    if (entry.itemType == ItemType.income.intVal) {
      dayIncome += entry.value;
      dailyCount++;
    }
    tmpList.add(entry);
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: AlertDialog(
                  scrollable: true,
                  content: Container(
                    height: min(400, minHeight),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin:EdgeInsets.fromLTRB(0, 0, 0, 10),
                              alignment: Alignment.centerLeft,
                              child: Text(tagName,
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700)))),
                          Expanded(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: MediaQuery.removePadding(
                                    removeTop: true,
                                    context: context,
                                    child: Column(children: accountSpending))),
                          ),
                        ]),
                  )));
        });
      });
}
