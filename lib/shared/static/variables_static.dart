import 'package:flutter/material.dart';

class VariablesStatic {
  static String get TOKEN => 'token';
  static String get expenseList => 'expenseList';
  static String get connection => 'https://www.google.com';
  static GlobalKey<OverlayState>  overleyKeyHome = GlobalKey<OverlayState>();
  static GlobalKey<OverlayState>  overleyKeyDetails = GlobalKey<OverlayState>();
}