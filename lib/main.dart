import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:processo_seletivo_onfly/app_widget.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const AppWidget());
}