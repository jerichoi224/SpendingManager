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
  int textLimit = 10;

  @override
  void initState() {
    super.initState();

    editingController.text = "";
    editingController.addListener(() {
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
              Container(
                height: 80,
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      editingController.text.isEmpty
                          ? "0"
                          : editingController.text,
                      style: const TextStyle(fontSize: 36),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              Center(
                child: customKeyboard(editingController, textLimit, null),
              )
            ],
          ),
        ));
  }
}
