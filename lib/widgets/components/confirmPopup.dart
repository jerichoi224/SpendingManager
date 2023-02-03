import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> confirmPopup(BuildContext context, String title, String content,
    String yes, String no) async {
  bool ret = false;
  await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            // The "Yes" button
            if (yes.isNotEmpty)
              TextButton(
                onPressed: () {
                  ret = true;
                  Navigator.of(ctx).pop();
                },
                child: Text(yes),
              ),
            if (no.isNotEmpty)
              TextButton(
                  onPressed: () {
                    ret = false;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(no)),
          ],
        );
      });
  return ret;
}
