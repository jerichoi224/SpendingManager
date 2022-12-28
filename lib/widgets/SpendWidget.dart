import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String tag = "";
  String account = "";
  String note = "";
  ItemType itemType = ItemType.expense;
  int textLimit = 10;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    resetAll();
    valueEditingController.addListener(() {
      setState(() {});
    });
  }

  Future<int> _selectDate(BuildContext context, DateTime dateTime) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2101)
    );
    if(pickedDate == null)
      return 0;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dateTime),
    );
    if(pickedTime == null)
      return 0;

    DateTime picked = new DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

    return picked.millisecondsSinceEpoch;
  }

  void resetAll()
  {
    account = "Bank A";
    tag = "Unknown";
    note = "YouTube Premium";
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
                  setState(() {
                    itemType = ItemType.values.byName(caption.toLowerCase());
                  });
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

  void saveItem()
  {
    if(itemType != ItemType.transfer)
    {
      SpendingEntry entry = SpendingEntry();
      entry.itemType = itemType.intVal;
      entry.caption = note;
      entry.dateTime = date.millisecondsSinceEpoch;
      entry.accId = 0;
      entry.tagId = tag;
      entry.value = double.parse(valueEditingController.text);

      if(itemType == ItemType.expense) {
        entry.value *= -1;
      }

      widget.datastore.spendingBox.put(entry);
    }
    else
    {
      SpendingEntry entrySpent = SpendingEntry();
      entrySpent.itemType = itemType.intVal;
      entrySpent.caption = note;
      entrySpent.dateTime = date.millisecondsSinceEpoch;
      entrySpent.accId = 0; // sending account
      entrySpent.tagId = "Transfer";
      entrySpent.value = double.parse(valueEditingController.text) * -1;

      SpendingEntry entryReceive = SpendingEntry();
      entryReceive.itemType = itemType.intVal;
      entryReceive.caption = note;
      entryReceive.dateTime = date.millisecondsSinceEpoch;
      entryReceive.accId = 0; // receiving account
      entryReceive.tagId = "Transfer";
      entryReceive.value = double.parse(valueEditingController.text);

      widget.datastore.spendingBox.put(entrySpent);
      widget.datastore.spendingBox.put(entryReceive);
    }

    widget.datastore.spendingList = widget.datastore.spendingBox.getAll();

    resetAll();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Column(
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
                    if(newTime != 0) {
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
                            fontSize: 16,
                            color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                )
              ),
              //************ MONEY AMOUNT ************//
              Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(0, 0 , 0, 0),
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
                            account,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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
                            tag,
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
                    const Spacer(),
                    Text(
                      note,
                      style: TextStyle(fontSize: 16),
                    ),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        highlightColor: Colors.blue,
                        onTap: () {
                          saveItem();
                          setState(() {
                          });
                        },
                        child: Center(
                          child: Text(
                            "Enter",
                            style: const TextStyle(fontSize: 24),
                          ),
                        )),
                  )),
              //************ Keyboard ************//
              Center(
                child: customKeyboard(valueEditingController, textLimit, null),
              )
            ],
          ),
        ));
  }
}
