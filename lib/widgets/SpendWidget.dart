import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/components/keyboardWidget.dart';

class SpendWidget extends StatefulWidget {
  final Datastore datastore;

  const SpendWidget({Key? key, required this.datastore}) : super(key: key);

  @override
  State createState() => _SpendState();
}

class _SpendState extends State<SpendWidget> {
  TextEditingController editingController = TextEditingController();
  String category = "";
  String account = "";
  String note = "";
  int textLimit = 10;

  @override
  void initState() {
    super.initState();
    account = "Bank A";
    category = "Unknown";
    note = "YouTube Premium";
    editingController.text = "";
    editingController.addListener(() {
      debugPrint(editingController.text);
      setState(() {});
    });
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
              //************ MONEY AMOUNT ************//
              Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      editingController.text.isEmpty
                          ? "0"
                          : editingController.text,
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
                          const Icon(
                            CarbonIcons.account,
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
                          const Icon(
                            CarbonIcons.tag,
                            color: Colors.black54,
                          ),
                          const Spacer(),
                          Text(
                            category,
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
              //************ Income Button ************//
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        height: 60,
                        margin: const EdgeInsets.fromLTRB(30, 5, 5, 0),
                        child: Ink(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: InkWell(
                              borderRadius: BorderRadius.circular(25.0),
                              highlightColor: Colors.blue,
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  "Income",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )),
                        )),
                  ),
                  //************ Spend Button ************//
                  Expanded(
                    child: Container(
                        height: 60,
                        margin: const EdgeInsets.fromLTRB(5, 5, 30, 0),
                        child: Ink(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              highlightColor: Colors.blue,
                              onTap: () {},
                              child: Center(
                                child: Text(
                                  "Spend",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )),
                        )),
                  ),
                ],
              ),
              Center(
                child: customKeyboard(editingController, textLimit, null),
              )
            ],
          ),
        ));
  }
}
