import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_color_models/flutter_color_models.dart';

List<Color> generatePallete(int n) {
  List<Color> pallete = [];
  Color color = Colors.blue.shade200;
  for (int i = 0; i < n; i++) {
    HslColor hslColor = HslColor.fromColor(color);
    pallete.add(hslColor.rotateHue((360 / n * i) % 360).toColor());
  }
  return pallete;
}