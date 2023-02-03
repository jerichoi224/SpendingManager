import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/components/confirmPopup.dart';
import 'package:spending_manager/widgets/components/editCaptionDialog.dart';

class ManageAccPageWidget extends StatefulWidget {
  late Datastore datastore;

  ManageAccPageWidget({
    Key? key,
    required this.datastore,
  }) : super(key: key);

  @override
  State createState() => _ManageAccPageState();
}

class _ManageAccPageState extends State<ManageAccPageWidget> {
  List<AccountEntry> accountList = [];

  @override
  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    accountList =
        widget.datastore.accountList.where((element) => element.show).toList();
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

  void openEditCaption(AccountEntry entry) async {
    final result = await editCaptionDialog(context, "Change Name", entry.caption);
    if (result.runtimeType == String) {
      entry.caption = result;
      widget.datastore.accountBox.put(entry);
      widget.datastore.accountList = widget.datastore.accountBox.getAll();
      updateList();
      setState(() {});
    }
  }

  void openAddAccount() async {
    final result = await editCaptionDialog(context, "Add Account", "");
    if (result.runtimeType == String) {
      widget.datastore.accountBox.put(AccountEntry(caption: result));
      widget.datastore.accountList = widget.datastore.accountBox.getAll();
      updateList();
      setState(() {});
    }
  }

  Widget _popUpMenuButton(AccountEntry entry) {
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
          openEditCaption(entry);
        }
        // Delete
        else if (selectedIndex == 1) {
          accountList.length == 1
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
                    widget.datastore.accountBox.put(entry);
                    widget.datastore.accountList =
                        widget.datastore.accountBox.getAll();
                    setState(() {
                      updateList();
                    });
                  }
                });
        }
      },
    );
  }

  Widget buildAccountList(BuildContext context, int index) {
    AccountEntry accountEntry = accountList[index];

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
      title: Text(
        accountEntry.caption,
        style: menuText,
      ),
      trailing: _popUpMenuButton(accountEntry),
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
                  "Accounts",
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  style: menuCategory,
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: accountList.length,
                    itemBuilder: buildAccountList,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  title: Row(
                    children: [
                      Text("Add New Account",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          )),
                    ],
                  ),
                  onTap: () {
                    openAddAccount();
                  },
                )
              ],
            )));
  }
}
