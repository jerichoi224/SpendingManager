import 'dart:math';

import 'package:flutter/material.dart';

Widget _buildList(int index, List<String> list) {
  list.sort();
  String item = list[index];
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      height: 60,
      child: InkWell(
        child: Center(
          child: Text(item),
        ),
        onTap: () {
          Navigator.of(context).pop(item);
        },
      ),
    );
  });
}

Future<dynamic> selectFromListPopup(
    BuildContext context, List<String> list) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              scrollable: true,
              content: SizedBox(
                // Increate size everytime a new warning is added
                height: min(400, 60.0 * list.length),
                width: 300,
                child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildList(index, list);
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                  ],
                ),
                )
              ));
        });
      });
}
