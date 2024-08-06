import 'package:flutter/material.dart';

extension date on DateTime {
  String get pickdate =>
      "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year}";
  String get pickTime =>
      "${(hour % 12).toString().padLeft(2, '0')} : ${minute.toString().padLeft(2, '0')} ${hour <= 12 ? 'AM' : 'PM'}";
}

extension sizedBox on int {
  SizedBox get h => SizedBox(
        height: this.toDouble(),
      );
  SizedBox get w => SizedBox(
        width: this.toDouble(),
      );
}
