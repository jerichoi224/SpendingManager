import 'package:flutter/material.dart';
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

class _CalendarState extends State<CalendarWidget>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String locale = "";
  int? year = 2000;
  int? month = 1;

  void initState() {
    super.initState();
    String? temp = widget.datastore.getPref("locale");
    locale = temp != null ? temp : 'en';
    DateTime now = new DateTime.now();

    year = now.year;
    month = now.month;
  }

  List<String> _getEventsForDay(DateTime day) {
    List<String> s = [];//widget.objectbox.sessionList.where((i)=>(isSameDay(day, DateTime.fromMillisecondsSinceEpoch(i.startTime)))).toList();
    return s;
  }

  Widget buildSessionCards(BuildContext context, int index) {
//    SessionEntry sessionEntry = sessionsToday[index];
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
        color: Colors.white,
        child: new InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () {},
            child: SizedBox(
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child:RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    height: 1.4
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(child: Container()),
                  ],
                )
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      TableCalendar(
                        availableGestures: AvailableGestures.none,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        rowHeight: 45,
                        calendarFormat: _calendarFormat,
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
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            // Call `setState()` when updating calendar format
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          if(focusedDay.runtimeType == DateTime) {
                            year = focusedDay.year;
                            month = focusedDay.month;
                          }
                          _focusedDay = focusedDay;
                          _selectedDay = focusedDay;
                        },
                        eventLoader: (day) {
                          return _getEventsForDay(day);
                        },
                      ),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          itemCount: 0,//sessionsToday.length,
                          itemBuilder: buildSessionCards,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ),
                    ]
                ),
              ),
            ],
          ),
        )
    );
  }
}