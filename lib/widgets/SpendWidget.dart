import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/util/enum.dart';
import 'package:spending_manager/widgets/components/keyboardWidget.dart';

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

  List<CategoryEntry> CategoryList = [];
  List<AccountEntry> AccountList = [];

  @override
  void initState() {
    super.initState();
    CategoryList = widget.datastore.categoryList;
    AccountList = widget.datastore.accountList;
    resetAll();
    valueEditingController.addListener(() {
      setState(() {});
    });
  }

  showSnackBar(BuildContext context, String s){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
      duration: Duration(seconds: 3),
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

  void resetAll() {
   account = AccountList[0];
   accountRec = AccountList[0];
   if(AccountList.length > 1) {
     accountRec = AccountList[1];
   }
   tag = CategoryList[0];
   valueEditingController.text = "";
   itemType = ItemType.expense;
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
                  if(caption == "Transfer" && AccountList.length < 2)
                    {
                      showSnackBar(context, "You cannot Transfer with less than 2 accounts");
                    }
                  else
                    {
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

  void saveItem() {
    if(valueEditingController.text.isEmpty)
      {
        return;
      }

    if (itemType != ItemType.transfer) {
      SpendingEntry entry = SpendingEntry();
      entry.itemType = itemType.intVal;
      entry.caption = noteEditingController.text;
      entry.dateTime = date.millisecondsSinceEpoch;
      entry.accId = 0;
      entry.tagId = tag.id;
      entry.value = double.parse(valueEditingController.text);

      if (itemType == ItemType.expense) {
        entry.value *= -1;
      }

      widget.datastore.spendingBox.put(entry);
    } else {
      SpendingEntry entry = SpendingEntry();
      entry.itemType = itemType.intVal;
      entry.caption = noteEditingController.text;
      entry.dateTime = date.millisecondsSinceEpoch;
      entry.accId = 0; // sending account
      entry.recAccId = 0; // receive account
      entry.tagId = CategoryList.firstWhere((e)=>e.caption == "Transfer").id;
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
            child:Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 64, // 64 = bottomnavbar
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                //************ DATE ************//
                Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      highlightColor: Colors.blue,
                      onTap: () async {
                        int newTime = await _selectDate(context, date);
                        if (newTime != 0) {
                          setState(() {
                            date = DateTime.fromMillisecondsSinceEpoch(newTime);
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('yyyy-MM-dd').format(date),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    )),
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
                            : valueEditingController.text,
                        style: const TextStyle(fontSize: 46),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    //************ ACCOUNT ************//
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.fromLTRB(30, 0, 5, 5),
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: InkWell(
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
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                    //************ CATEGORY ************//
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.fromLTRB(5, 0, 30, 5),
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15)),
                        ),
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
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
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
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                            border: InputBorder.none
                          ),
                          textAlign: TextAlign.end,
                          controller: noteEditingController,
                          style: const TextStyle(
                              fontSize: 16
                          ),
                        ),
                      )
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
                Center(
                  child:
                  customKeyboard(valueEditingController, textLimit, null),
                )
              ],
            )
          )
        )
      )
    );
  }
}
