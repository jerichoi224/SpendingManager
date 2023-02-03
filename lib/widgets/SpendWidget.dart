import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/enum.dart';
import 'package:spending_manager/util/numberFormat.dart';
import 'package:spending_manager/widgets/components/datePicker.dart';
import 'package:spending_manager/widgets/components/keyboardWidget.dart';
import 'package:spending_manager/widgets/components/selectFromListPopup.dart';

class SpendWidget extends StatefulWidget {
  final Datastore datastore;

  const SpendWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _SpendState();
}

class _SpendState extends State<SpendWidget> {
  TextEditingController valueEditingController = TextEditingController();
  TextEditingController noteEditingController = TextEditingController();

  late CategoryEntry tag;
  late AccountEntry account;
  late AccountEntry accountRec;

  ItemType itemType = ItemType.expense;
  int textLimit = 10;
  DateTime date = DateTime.now();

  List<CategoryEntry> categoryList = [];
  List<AccountEntry> accountList = [];

  String locale = "ko_KR";

  @override
  void initState() {
    super.initState();
    categoryList = widget.datastore.categoryList.where((element) => element.show).toList();
    accountList = widget.datastore.accountList.where((element) => element.show).toList();
    resetAll();
    tag = categoryList.firstWhere((element) => element.caption == "Other");
    itemType = ItemType.expense;
    account = accountList[0];
    accountRec = accountList[0];
    if (accountList.length > 1) {
      accountRec = accountList[1];
    }

    valueEditingController.addListener(() {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {});
    });
  }

  showSnackBar(BuildContext context, String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
      duration: const Duration(seconds: 2),
    ));
  }

  void resetAll() {
    valueEditingController.text = "";
    noteEditingController.text = "";
  }

  Widget toggleButton(String caption) {
    return Expanded(
      child: Container(
          height: 40,
          margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: Ink(
            height: 40,
            decoration: BoxDecoration(
              color: caption.toUpperCase() == itemType.string.toUpperCase()
                  ? Colors.blue.shade300
                  : Colors.blue.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                highlightColor: Colors.blue,
                onTap: () {
                  if (caption == "Transfer" && accountList.length < 2) {
                    Fluttertoast.showToast(
                      msg: "You cannot transfer with one account",
                    );
                  } else {
                    setState(() {
                      itemType = ItemType.values.byName(caption.toLowerCase());
                    });
                  }
                },
                child: Center(
                  child: Text(
                    caption,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
          )),
    );
  }

  Future<String> selectFromList(BuildContext context, List<String> list) async {
    final result = await selectFromListPopup(context, list);
    if (result != null) {
      return result;
    }
    return "";
  }

  void saveItem() {
    if (valueEditingController.text.isEmpty) {
      showSnackBar(context, "Must enter a value");
      return;
    }

    if (noteEditingController.text.isEmpty) {
      {
        showSnackBar(context, "Please Enter Note");
        return;
      }
    }

    if (itemType == ItemType.transfer && account.id == accountRec.id) {
      showSnackBar(context, "Cannot Transfer to Same Account");
      return;
    }

    if (itemType != ItemType.transfer) {
      SpendingEntry entry = SpendingEntry();
      entry.itemType = itemType.intVal;
      entry.caption = noteEditingController.text;
      entry.dateTime = date.millisecondsSinceEpoch;
      entry.accId = account.id;
      entry.tagId = tag.id;
      entry.value = double.parse(valueEditingController.text);

      if (itemType == ItemType.income) {
        entry.excludeFromSpending = true;
      } else {
        entry.excludeFromIncome = true;
      }

      if (itemType == ItemType.expense) {
        entry.value *= -1;
      }

      widget.datastore.spendingBox.put(entry);
    } else {
      SpendingEntry entry = SpendingEntry();
      entry.itemType = itemType.intVal;
      entry.caption = noteEditingController.text;
      entry.dateTime = date.millisecondsSinceEpoch;
      entry.accId = account.id; // sending account
      entry.recAccId = accountRec.id; // receive account
      entry.excludeFromSpending = true;
      entry.excludeFromIncome = true;
      entry.tagId = categoryList.firstWhere((e) => e.caption == "Transfer").id;
      entry.value = double.parse(valueEditingController.text) * -1;
      widget.datastore.spendingBox.put(entry);
    }

    widget.datastore.spendingList = widget.datastore.spendingBox.getAll();

    resetAll();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        64, // 64 = bottomnavbar
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        //************ DATE ************//
                        datePicker(context, date, (DateTime newVal) {
                          setState(() {
                            date = newVal;
                          });
                        }, false),
                        //************ MONEY AMOUNT ************//
                        Container(
                          height: 80,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                valueEditingController.text.isEmpty
                                    ? "0"
                                    : moneyFormat(valueEditingController.text,
                                        locale, true),
                                style: const TextStyle(fontSize: 46),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        //************ Three Toggles ************//
                        Container(
                          margin: const EdgeInsets.fromLTRB(28, 0, 28, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              toggleButton("Income"),
                              toggleButton("Transfer"),
                              toggleButton("Expense"),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            //************ ACCOUNT ************//
                            Expanded(
                              child: Container(
                                  height: 40,
                                  margin:
                                      const EdgeInsets.fromLTRB(30, 0, 5, 5),
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      String newAccount = await selectFromList(
                                          context,
                                          accountList
                                              .map((e) => e.caption)
                                              .toList());
                                      if (newAccount.isNotEmpty) {
                                        setState(() {
                                          account = accountList.firstWhere(
                                              (element) =>
                                                  element.caption ==
                                                  newAccount);
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          itemType.string == "transfer"
                                              ? CarbonIcons.logout
                                              : CarbonIcons.account,
                                          color: Colors.black54,
                                        ),
                                        const Spacer(),
                                        Text(
                                          account.caption,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            //************ CATEGORY ************//
                            Expanded(
                              child: Container(
                                  height: 40,
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 30, 5),
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      if (itemType.string != "transfer") {
                                        String newAccount =
                                            await selectFromList(
                                                context,
                                                categoryList
                                                    .where((item) {
                                                      return item.caption !=
                                                          "Transfer";
                                                    })
                                                    .map((e) => e.caption)
                                                    .toList());
                                        if (newAccount.isNotEmpty) {
                                          setState(() {
                                            tag = categoryList.firstWhere(
                                                (element) =>
                                                    element.caption ==
                                                    newAccount);
                                          });
                                        }
                                      } else {
                                        String newAccount =
                                            await selectFromList(
                                                context,
                                                accountList
                                                    .map((e) => e.caption)
                                                    .toList());
                                        if (newAccount.isNotEmpty) {
                                          setState(() {
                                            accountRec = accountList.firstWhere(
                                                (element) =>
                                                    element.caption ==
                                                    newAccount);
                                          });
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          itemType.string == "transfer"
                                              ? CarbonIcons.login
                                              : CarbonIcons.tag,
                                          color: Colors.black54,
                                        ),
                                        const Spacer(),
                                        Text(
                                          itemType.string == "transfer"
                                              ? accountRec.caption
                                              : tag.caption,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        //************ NOTE ************//
                        Container(
                          height: 40,
                          margin: const EdgeInsets.fromLTRB(30, 0, 30, 5),
                          padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                CarbonIcons.catalog,
                                color: Colors.black54,
                              ),
                              Flexible(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      hintText: 'Enter Note',
                                      border: InputBorder.none),
                                  textAlign: TextAlign.end,
                                  controller: noteEditingController,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        //************ Enter Button ************//
                        Container(
                            height: 60,
                            margin: const EdgeInsets.fromLTRB(30, 0, 30, 5),
                            child: Ink(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade400,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  highlightColor: Colors.blue,
                                  onTap: () {
                                    saveItem();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {});
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Enter",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  )),
                            )),
                        //************ Keyboard ************//
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Center(
                            child: customKeyboard(
                                valueEditingController, textLimit, null),
                          ),
                        )
                      ],
                    )))));
  }
}
