import 'dart:ui';

import 'package:flutter/material.dart';

class BaseTheme {
  List<Color> colorPallete = [
    Colors.white,
    Color(0xffEEF2F9),
  ];

  Color get white => this.colorPallete[0];
  Color get lightWhite => this.colorPallete[1];
}
