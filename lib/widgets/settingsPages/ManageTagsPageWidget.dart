import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/accountEntry.dart';
import 'package:spending_manager/dbModels/categoryEntry.dart';
import 'package:spending_manager/util/dbTool.dart';
import 'package:spending_manager/widgets/components/confirmPopup.dart';
import 'package:spending_manager/widgets/components/editCaptionDialog.dart';

class ManageTagsPageWidget extends StatefulWidget {
  late Datastore datastore;

  ManageTagsPageWidget({
    Key? key,
    required this.datastore,
  }) : super(key: key);

  @override
  State createState() => _ManageTagsPageState();
}

class _ManageTagsPageState extends State<ManageTagsPageWidget> {
  List<CategoryEntry> tagsList = [];

  @override
  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    widget.datastore.categoryList = widget.datastore.categoryBox.getAll();
    tagsList =
        widget.datastore.categoryList.where((element) => element.show).toList();
    setState(() {});
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

  void openEditCaption(CategoryEntry entry) async {
    final result =
        await editCaptionDialog(context, "Change Name", entry.caption);
    if (result.runtimeType == String) {
      entry.caption = result;
      widget.datastore.categoryBox.put(entry);

      updateList();
    }
  }

  void openAddCategory() async {
    final result = await editCaptionDialog(context, "Add Category", "");
    if (result.runtimeType == String) {
      widget.datastore.categoryBox.put(CategoryEntry(caption: result, iconId: 12, basic: false));
      updateList();
    }
  }

  Widget _popUpMenuButton(CategoryEntry entry) {
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
          if(entry.basic){
            Fluttertoast.showToast(msg: "You cannot delete this category.");
            return;
          }
          confirmPopup(
                  context,
                  "Delete Account?",
                  "Previous records in this category will remain, but you will no longer be able to add entries using this category.",
                  "Yes",
                  "No")
              .then((value) {
            if (value) {
              entry.show = false;
              widget.datastore.categoryBox.put(entry);
              updateList();
            }
          });
        }
      },
    );
  }

  Widget buildAccountList(BuildContext context, int index) {
    CategoryEntry accountEntry = tagsList[index];

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
                  "Category",
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  style: menuCategory,
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: tagsList.length,
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
                      Text("Add New Category",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          )),
                    ],
                  ),
                  onTap: () {
                    openAddCategory();
                  },
                )
              ],
            )));
  }
}
