import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  late Datastore datastore;

  CalendarWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _CalendarState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class _CalendarState extends State<CalendarWidget> {
  List<SpendingEntry> entryList = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    entryList = widget.datastore.spendingList;
    super.initState();
  }

  List<SpendingEntry> _getSpendingCount(DateTime day) {
    List<SpendingEntry> s = widget.datastore.spendingList
        .where((i) =>
            (isSameDay(day, DateTime.fromMillisecondsSinceEpoch(i.dateTime))))
        .toList();
    return s;
  }

  List<Widget> spendingHistory() {
    if (entryList.isEmpty) {
      return [
        Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: const Center(child: Text("No record found")))
      ];
    }
    List<Widget> historyList = [
      SizedBox(
        height: 20,
      )
    ];
    List<SpendingEntry> tmpList = [];
    double daySum = 0;

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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                daySum.toString(),
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                  fontSize: 16,
                )),
              )
            ],
          ),
        ));

        historyList.add(const Divider(
          indent: 10,
          thickness: 1.0,
          endIndent: 10,
          height: 10,
          color: Colors.black,
        ));

        for (SpendingEntry item in tmpList) {
          historyList.add(Container(
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: ListTile(
                visualDensity: VisualDensity(vertical: -2),
                dense: false,
                leading: Icon(CarbonIcons.arrows_horizontal),
                title: Text(
                  item.caption,
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                    fontSize: 16,
                  )),
                ),
                subtitle: Text(item.itemType.toString()),
                trailing: Text(
                  item.value.toString(),
                  style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                    fontSize: 16,
                  )),
                ),
              )));
        }

        currentDay = entryDay;
        currentDate = entryDate;
        tmpList.clear();
        daySum = 0;
      }

      daySum += entry.value;
      tmpList.add(entry);
    }

    return historyList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  "Calendar Timeline",
                  style: TextStyle(color: Colors.black87),
                )),
            body: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.week,
                  headerStyle: const HeaderStyle(formatButtonVisible: false),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: spendingHistory(),
                    ),
                  ),
                )
              ],
            )));
  }
}
