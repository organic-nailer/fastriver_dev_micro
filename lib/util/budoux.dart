import 'package:budoux_dart/budoux.dart';
import 'package:flutter/services.dart';

class BudouxUtil {
  factory BudouxUtil() => _instance;

  BudouxUtil._internal();

  static final BudouxUtil _instance = BudouxUtil._internal();

  BudouX? budoux;

  Future<void> init() async {
    final dict = await rootBundle.loadString("asset/ja.json");
    budoux = BudouX(dict);
  }

  List<String> parse(String text) {
    return budoux!.parse(text);
  }
}
