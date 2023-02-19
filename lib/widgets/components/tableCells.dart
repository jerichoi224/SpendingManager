import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Widget cellTitleText(String text, Alignment alignment) {
  return Container(
      height: 40,
      alignment: alignment,
      child: Text(text,
          style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700))));
}

Widget cellContentText(String text, Alignment alignment, double height) {
  return Container(
      height: height,
      alignment: alignment,
      child: Text(text,
          style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w400))));
}