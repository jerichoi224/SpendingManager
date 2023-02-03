import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/StringUtil.dart';
import 'package:spending_manager/util/dbTool.dart';
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
          style: const TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold),
        ),
      ));
}

TextStyle latoFont(double size) {
  return GoogleFonts.lato(textStyle: TextStyle(fontSize: size));
}

Future<dynamic> viewEditTransferPopup(
    BuildContext context, Datastore datastore, int spendingId) async {
  String locale = "ko_KR";
  bool useDecimal = usesDecimal(locale);

  SpendingEntry item =
      datastore.spendingList.firstWhere((element) => element.id == spendingId);
  String fromAccount = datastore.accountList
      .firstWhere((element) => element.id == item.accId)
      .caption;
  String toAccount = datastore.accountList
      .firstWhere((element) => element.id == item.recAccId)
      .caption;

  String selectedTag = datastore.categoryList
      .firstWhere((element) => element.id == item.tagId)
      .caption;

  DateTime date = DateTime.fromMillisecondsSinceEpoch(item.dateTime);

  TextEditingController amountController = TextEditingController();
  if (!useDecimal) {
    amountController.text = item.value.abs().toInt().toString();
  } else {
    amountController.text = item.value.abs().toString();
  }

  List<AccountEntry> accountList = datastore.accountList.where((element) => element.show).toList();
  AccountEntry acc = datastore.accountList.firstWhere((element) => element.id == item.accId);
  AccountEntry recAcc = datastore.accountList.firstWhere((element) => element.id == item.recAccId);
  if(!acc.show) {
    accountList.add(acc);
  }
  if(!recAcc.show) {
    accountList.add(acc);
  }

  TextEditingController noteController = TextEditingController();
  noteController.text = item.caption;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: AlertDialog(
                  scrollable: true,
                  content: Container(
                    height: 400,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Row(children: [
                              Text(
                                "Transfer",
                                style: latoFont(24),
                              ),
                              const Spacer(),
                              datePicker(context, date, (DateTime newVal) {
                                setState(() {
                                  date = newVal;
                                });
                              }, true),
                            ])),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                "From",
                                style: latoFont(16),
                              ),
                              const Spacer(),
                              dropdownMenu(
                                  context,
                                  accountList
                                      .map((account) =>
                                          DropdownMenuItem<String>(
                                            value: account.caption,
                                            child: Text(account.caption,
                                                overflow: TextOverflow.ellipsis,
                                                style: latoFont(14)),
                                          ))
                                      .toList(),
                                  fromAccount, (value) {
                                setState(() {
                                  fromAccount = value;
                                });
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                "To",
                                style: latoFont(16),
                              ),
                              const Spacer(),
                              dropdownMenu(
                                  context,
                                  accountList
                                      .map((account) =>
                                          DropdownMenuItem<String>(
                                            value: account.caption,
                                            child: Text(account.caption,
                                                overflow: TextOverflow.ellipsis,
                                                style: latoFont(14)),
                                          ))
                                      .toList(),
                                  toAccount, (value) {
                                setState(() {
                                  toAccount = value;
                                });
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Text(
                                "Amount",
                                style: latoFont(16),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: 160,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                ),
                                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.end,
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  style: latoFont(16),
                                  inputFormatters: [
                                    useDecimal
                                        ? FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}'))
                                        : FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Text(
                            "Note",
                            style: latoFont(16),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.black26,
                              ),
                            ),
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                            child: TextField(
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                controller: noteController,
                                keyboardType: TextInputType.multiline,
                                style: latoFont(16)),
                          ),
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            actionButton("Delete", () {
                              datastore.spendingBox.remove(item.id);
                              datastore.spendingList =
                                  datastore.spendingBox.getAll();
                              Navigator.pop(context, true);
                            }),
                            actionButton("Save", () {
                              if (toAccount == fromAccount) return;
                              item.caption = noteController.text;
                              if (!amountController.text.isNumeric()) return;
                              item.value =
                                  double.parse(amountController.text) * -1;
                              item.accId = datastore.accountList
                                  .firstWhere((element) =>
                                      element.caption == fromAccount)
                                  .id;
                              item.recAccId = datastore.accountList
                                  .firstWhere(
                                      (element) => element.caption == toAccount)
                                  .id;
                              item.tagId = datastore.categoryList
                                  .firstWhere((element) =>
                                      element.caption == selectedTag)
                                  .id;

                              item.dateTime = date.millisecondsSinceEpoch;

                              datastore.spendingBox.put(item);
                              datastore.spendingList =
                                  datastore.spendingBox.getAll();
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
