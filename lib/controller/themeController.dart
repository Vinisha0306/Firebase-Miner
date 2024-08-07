import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  bool isdark = false;

  void ChangeTheme() {
    isdark = !isdark;
    print('${isdark}');
    notifyListeners();
  }
}
