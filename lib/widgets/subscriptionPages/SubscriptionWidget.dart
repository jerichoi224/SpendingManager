import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/subscriptionEntry.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/components/confirmPopup.dart';
import 'package:spending_manager/widgets/components/editCaptionDialog.dart';
import 'package:spending_manager/widgets/subscriptionPages/AddEditSubscriptionWidget.dart';

class SubscriptionWidget extends StatefulWidget {
  late Datastore datastore;

  SubscriptionWidget({
    Key? key,
    required this.datastore,
  }) : super(key: key);

  @override
  State createState() => _SubscriptionState();
}

class _SubscriptionState extends State<SubscriptionWidget> {
  List<SubscriptionEntry> subscriptionList = [];

  @override
  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    subscriptionList = widget.datastore.subscirptionList
        .where((element) => element.show)
        .toList();
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

  void openEditSubscription(SubscriptionEntry entry) async {
    final result =
        await editCaptionDialog(context, "Change Name", entry.caption);
    if (result.runtimeType == String) {
      entry.caption = result;
      widget.datastore.subscriptionBox.put(entry);
      widget.datastore.subscirptionList =
          widget.datastore.subscriptionBox.getAll();
      updateList();
      setState(() {});
    }
  }

  void openAddSubscription() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEditSubscriptionWidget(
            datastore: widget.datastore,
            edit: false,
          ),
        ));
    setState(() {
      updateList();
    });
  }

  Widget _popUpMenuButton(SubscriptionEntry entry) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Text("Edit"),
        ),
        const PopupMenuItem(
          value: 1,
          child: Text("Delete"),
        ),
      ],
      onSelected: (selectedIndex) {
        // Edit
        if (selectedIndex == 0) {
          openEditSubscription(entry);
        }
        // Delete
        else if (selectedIndex == 1) {
          subscriptionList.length == 1
              ? Fluttertoast.showToast(
                  msg: "You need to keep at least one account",
                )
              : confirmPopup(
                      context,
                      "Delete Account?",
                      "Previous records of this account will remain, but you will no longer be able to add entries using this account.",
                      "Yes",
                      "No")
                  .then((value) {
                  if (value) {
                    entry.show = false;
                    widget.datastore.subscriptionBox.put(entry);
                    widget.datastore.subscirptionList =
                        widget.datastore.subscriptionBox.getAll();
                    setState(() {
                      updateList();
                    });
                  }
                });
        }
      },
    );
  }

  Widget buildSubscriptionList(BuildContext context, int index) {
    SubscriptionEntry subscriptionEntry = subscriptionList[index];

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
      title: Text(
        subscriptionEntry.caption,
        style: menuText,
      ),
      trailing: _popUpMenuButton(subscriptionEntry),
      onTap: () {},
    );
  }

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
                  "Subscriptions",
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  style: menuCategory,
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: subscriptionList.length,
                    itemBuilder: buildSubscriptionList,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  title: Row(
                    children: [
                      Text("Add New Subscription",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          )),
                    ],
                  ),
                  onTap: () {
                    openAddSubscription();
                  },
                )
              ],
            )));
  }
}
