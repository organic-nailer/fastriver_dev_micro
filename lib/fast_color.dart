import 'package:flutter/material.dart';
import 'dart:math';

const materialFastGreen = MaterialColor(0xFF60807E, {
  50: Color(0xFFCFE6E5),
  100: Color(0xFFACE6E4),
  200: Color(0xFF99CCCA),
  300: Color(0xFF86B3B1),
  400: Color(0xFF739998),
  500: Color(0xFF60807E),
  600: Color(0xFF567372),
  700: Color(0xFF4D6665),
  800: Color(0xFF435959),
  900: Color(0xFF394D4C),
});

const goodColors = [
  Colors.red,
  Colors.purple,
  Colors.indigo,
  Colors.blue,
  Colors.cyan,
  Colors.green,
  Colors.amber,
  Colors.deepOrange,
  Colors.grey
];

Color randomGoodColors() => goodColors[Random().nextInt(goodColors.length)];
