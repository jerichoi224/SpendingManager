import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/subscriptionEntry.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/components/confirmPopup.dart';
import 'package:spending_manager/widgets/components/editCaptionDialog.dart';

class AddEditSubscriptionWidget extends StatefulWidget {
  late Datastore datastore;
  late bool edit;

  AddEditSubscriptionWidget(
      {Key? key, required this.datastore, required this.edit})
      : super(key: key);

  @override
  State createState() => _AddEditSubscriptionState();
}

class _AddEditSubscriptionState extends State<AddEditSubscriptionWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget paddedText(String text, {EdgeInsets? padding, TextStyle? style}) {
    return Padding(
        padding: padding ?? const EdgeInsets.all(5),
        child: Text(
          text,
          style: style ?? const TextStyle(color: Colors.black),
        ));
  }

  TextStyle menuCategory = GoogleFonts.lato(
      textStyle: TextStyle(
          color: Colors.blueAccent.shade200,
          fontWeight: FontWeight.bold,
          fontSize: 22));

  TextStyle menuText = GoogleFonts.lato(
      textStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15));

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mediaQueryData.viewPadding.top,
                ),
                paddedText(
                  widget.edit ? "Edit Subsciprtion" : "New Subscription",
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  style: menuCategory,
                ),
              ],
            )));
  }
}
