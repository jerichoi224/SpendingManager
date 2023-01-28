import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget datePicker(BuildContext context, DateTime date, Function update, bool transparentBackground) {
  return Container(
      height: 30,
      width: 120,
      decoration: BoxDecoration(
        color: transparentBackground ? Colors.transparent : Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(5.0),
        highlightColor: Colors.blue,
        onTap: () async {
          int newTime = await _selectDate(context, date);
          if (newTime != 0) {
            update(DateTime.fromMillisecondsSinceEpoch(newTime));
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('yyyy-MM-dd').format(date),
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ));
}

Future<int> _selectDate(BuildContext context, DateTime dateTime) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2101));
  if (pickedDate == null) return 0;

  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(dateTime),
  );
  if (pickedTime == null) return 0;

  DateTime picked = DateTime(pickedDate.year, pickedDate.month,
      pickedDate.day, pickedTime.hour, pickedTime.minute);

  return picked.millisecondsSinceEpoch;
}