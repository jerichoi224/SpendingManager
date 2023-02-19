import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/enum.dart';
import 'package:spending_manager/util/numberFormat.dart';
import 'package:spending_manager/util/categoryIconMap.dart';
import 'package:spending_manager/widgets/components/viewEditSpendingPopup.dart';
import 'package:spending_manager/widgets/components/viewEditTransferPopup.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  late Datastore datastore;

  CalendarWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _CalendarState();
}

class _CalendarState extends State<CalendarWidget> {
  Map<String, CalendarFormat> calendarFormatMap = {
    'Month': CalendarFormat.month,
    '2 weeks': CalendarFormat.twoWeeks,
    'Week': CalendarFormat.week,
  };
  Map<CalendarFormat, String> calendarFormatnameMap = {
    CalendarFormat.month: 'Month',
    CalendarFormat.twoWeeks: '2 weeks',
    CalendarFormat.week: 'Week',
  };

  Map<int, Color> itemTypeColor = {
    ItemType.income.intVal: Colors.blue,
    ItemType.expense.intVal: Colors.black,
  };

  CalendarFormat _calendarFormat = CalendarFormat.week;

  Map<int, String> accIdString = {};

  List<SpendingEntry> entryList = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String locale = "";
  String currency = "";

  @override
  void initState() {
    updateState();
    locale = widget.datastore.getPref("locale") ?? "en";
    currency = widget.datastore.getPref("currency") ?? "KRW";

    if (widget.datastore.prefMap.keys.contains("calendar_format")) {
      _calendarFormat =
          calendarFormatMap[widget.datastore.getPref("calendar_format")]!;
    }
    for (AccountEntry entry in widget.datastore.accountList) {
      accIdString[entry.id] = entry.caption;
    }

    super.initState();
  }

  updateState() {
    entryList = widget.datastore.spendingList;
  }

  List<SpendingEntry> _getSpendingCount(DateTime day) {
    List<SpendingEntry> s = widget.datastore.spendingList
        .where((i) =>
            (isSameDay(day, DateTime.fromMillisecondsSinceEpoch(i.dateTime))))
        .toList();
    return s;
  }

  Widget moneyText(SpendingEntry item, bool receiveAcc) {
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

  void openSpendingItem(BuildContext context, int entryId) async {
    SpendingEntry item = widget.datastore.spendingList
        .firstWhere((element) => element.id == entryId);
    CategoryEntry tag = widget.datastore.categoryList
        .firstWhere((element) => element.id == item.tagId);
    var result = false;
    if (tag.caption == "Transfer") {
      result =
          await viewEditTransferPopup(context, widget.datastore, entryId) ??
              false;
    } else {
      result =
          await viewEditSpendingPopup(context, widget.datastore, entryId) ??
              false;
    }
    if (result) {
      setState(() {
        updateState();
      });
    }
  }

  List<Widget> spendingHistory() {
    if (entryList.isEmpty) {
      return [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: const Center(child: Text("No record found")))
      ];
    }

    List<Widget> historyList = [
      const SizedBox(
        height: 20,
      )
    ];
    List<SpendingEntry> tmpList = [];
    double dayExpense = 0;
    double dayIncome = 0;

    entryList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
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
        historyList.add(Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 20, 0),
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('MMM d, EEE').format(currentDate),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              dayExpense != 0
                  ? Text(
                      moneyFormat(dayExpense.toString(), currency, true),
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    )
                  : Container(),
            ],
          ),
        ));

        historyList.add(const Divider(
          indent: 10,
          endIndent: 10,
          height: 10,
          thickness: 0.7,
          color: Colors.black54,
        ));

        for (SpendingEntry item in List.from(tmpList.reversed)) {
          if (item.itemType == ItemType.transfer.intVal) // Receive Entry
          {
            historyList.add(Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      openSpendingItem(context, item.id);
                    },
                    child: ListTile(
                        visualDensity: const VisualDensity(vertical: -2),
                        dense: false,
                        leading: Icon(
                          categoryIconMap[item.tagId],
                          color: Colors.black,
                        ),
                        title: Text(
                          item.caption,
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            fontSize: 16,
                          )),
                        ),
                        subtitle: Text(accIdString[item.recAccId]!),
                        trailing: moneyText(item, true)))));
          }
          historyList.add(Container(
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  openSpendingItem(context, item.id);
                },
                child: ListTile(
                    visualDensity: const VisualDensity(vertical: -2),
                    dense: false,
                    leading: Icon(
                      categoryIconMap[item.tagId],
                      color: Colors.black,
                      size: 28,
                    ),
                    title: Text(
                      item.caption,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        fontSize: 16,
                      )),
                    ),
                    subtitle: Text(accIdString[item.accId]!),
                    trailing: moneyText(item, false)),
              )));
        }

        currentDay = entryDay;
        currentDate = entryDate;
        tmpList.clear();
        dayExpense = 0;
        dayIncome = 0;
      }

      if (entry.itemType == ItemType.expense.intVal &&
          !entry.excludeFromSpending) {
        dayExpense += entry.value;
      }
      if (entry.itemType == ItemType.income.intVal &&
          !entry.excludeFromIncome) {
        dayIncome += entry.value;
      }
      tmpList.add(entry);
    }

    return historyList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      widget.datastore.setPref(
                          "calendar_format", calendarFormatnameMap[format]);
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  eventLoader: (day) {
                    return _getSpendingCount(day);
                  },
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 10,
                  color: Colors.grey.shade100,
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
                          children: spendingHistory(),
                        ),
                      )),
                )
              ],
            )));
  }
}
