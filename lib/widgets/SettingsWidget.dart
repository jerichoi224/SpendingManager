import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/settingsPages/ManageAccountPageWidget.dart';
import 'package:spending_manager/widgets/settingsPages/ManageTagsPageWidget.dart';

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

  Widget div = const Divider(
    height: 1,
    color: Colors.grey,
  );

  TextStyle menuCategory = GoogleFonts.lato(
      textStyle: TextStyle(
          color: Colors.blueAccent.shade200,
          fontWeight: FontWeight.bold,
          fontSize: 22));

  TextStyle menuText = GoogleFonts.lato(
      textStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15));

  Widget paddedText(String text, {EdgeInsets? padding, TextStyle? style}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(5),
        child: Text(
          text,
          style: style ?? const TextStyle(color: Colors.black),
        ));
  }

  void _openManageAccPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageAccPageWidget(
            datastore: widget.datastore,
          ),
        ));
  }

  void _openManageTagPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageTagsPageWidget(
            datastore: widget.datastore,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: SizedBox(
                    width: mediaQueryData.size.width,
                    height: mediaQueryData.size.height - 64,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: mediaQueryData.viewPadding.top,
                          ),
                          paddedText(
                            "Settings",
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            style: menuCategory,
                          ),
                          ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            title: Text(
                              "Manage Accounts",
                              style: menuText,
                            ),
                            onTap: () {
                              _openManageAccPage();
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(25, 0, 20, 0),
                            title: Text(
                              "Manage Categories",
                              style: menuText,
                            ),
                            onTap: () {
                              _openManageTagPage();
                            },
                          ),
                          div,
                        ])))));
  }
}
