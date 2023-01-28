import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

Widget dropdownMenu(
    BuildContext context,
    List<DropdownMenuItem<Object>> itemList,
    Object selectedValue,
    Function onchange) {
  return DropdownButton2(
    items: itemList,
    value: selectedValue,
    onChanged: (value) {
      onchange(value);
    },
    underline: Container(
      height: 0.0,
    ),
    buttonHeight: 50,
    buttonWidth: 160,
    buttonPadding: const EdgeInsets.only(left: 14, right: 14),
    buttonDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: Colors.black26,
      ),
    ),
    itemHeight: 40,
    itemPadding: const EdgeInsets.only(left: 14, right: 14),
    dropdownMaxHeight: 200,
    dropdownWidth: 160,
    dropdownPadding: null,
    dropdownDecoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
    ),
    dropdownElevation: 8,
    scrollbarRadius: const Radius.circular(40),
    scrollbarThickness: 6,
    scrollbarAlwaysShow: true,
  );
}
