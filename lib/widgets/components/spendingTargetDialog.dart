import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/StringUtil.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/enum.dart';
import 'package:spending_manager/util/numberFormat.dart';
import 'package:spending_manager/widgets/components/datePicker.dart';
import 'package:spending_manager/widgets/components/dropdownComponent.dart';

Widget actionButton(String text, Function onClick) {
  return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        onClick();
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Text(
          text,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold),
          ),
        ),
      ));
}

TextStyle latoFont(double size) {
  return GoogleFonts.lato(textStyle: TextStyle(fontSize: size));
}

Future<dynamic> spendingTargetDialog(
    BuildContext context, Datastore datastore) async {
  String locale = "ko_KR";
  bool useDecimal = usesDecimal(locale);
  TextEditingController targetController = TextEditingController();
  double dailyTarget = datastore.getPref("daily_target") ?? 0;
  if (!useDecimal) {
    targetController.text = dailyTarget.toInt().toString();
  } else {
    targetController.text = dailyTarget.toString();
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
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Text(
                            "Set Daily Target",
                            style: latoFont(20),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          padding: const EdgeInsets.all(10),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                          ),
                          child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              textAlign: TextAlign.end,
                              controller: targetController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                useDecimal
                                    ? FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'))
                                    : FilteringTextInputFormatter.digitsOnly
                              ],
                              style: latoFont(16)),
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            actionButton("Cancel", () {
                              Navigator.pop(context, false);
                            }),
                            actionButton("Save", () {
                              datastore.setPref("daily_target",
                                  double.parse(targetController.text));
                              Navigator.pop(context, true);
                            }),
                          ],
                        ),
                      ],
                    ),
                  )));
        });
      });
}
