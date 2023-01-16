import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spending_manager/dbModels/spending_entry_model.dart';
import 'package:spending_manager/util/dbTool.dart';

Future<dynamic> viewEditSpendingPopup(
    BuildContext context, Datastore datastore, int spendingId) async {
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool editMode = false;
  SpendingEntry item =
      datastore.spendingList.firstWhere((element) => element.id == spendingId);

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              scrollable: true,
              content: SizedBox(
                // Increate size everytime a new warning is added
                height: editMode ? 370 : 250,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: editMode
                          ? []
                          : [
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    editMode = true;
                                  });
                                },
                                icon: const Icon(
                                  CarbonIcons.edit,
                                  color: Colors.black54,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  CarbonIcons.trash_can,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                    ),
                    Text(
                      datastore.accountList
                          .firstWhere((element) => element.id == item.accId)
                          .caption,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 16, color: Colors.black87)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      //apply padding to all four sides
                      child: Text(
                        item.value.toString(),
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                          fontSize: 24,
                        )),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Colors.black54, width: 1.4)),
                      child: Text(
                        datastore.categoryList
                            .firstWhere((element) => element.id == item.tagId)
                            .caption,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.black54)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                          style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                            fontSize: 20,
                          )),
                        ),
                      ),
                    ),
                    editMode ? const Spacer() : Container(),
                    Container(
                      child: editMode
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                  customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            )
                          : null,
                    )
                  ],
                ),
              ));
        });
      });
}
