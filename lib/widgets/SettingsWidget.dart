import 'package:flutter/material.dart';
import 'package:spending_manager/util/dbTool.dart';

class SettingsWidget extends StatefulWidget {
  late Datastore datastore;

  SettingsWidget({
    Key? key,
    required this.datastore,
  }) : super(key: key);

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "",
            style: TextStyle(color: Colors.black87),
          )),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                64, // 64 = bottomnavbar
            child: Column()
          )
        )
      )
    );
  }
}
