import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:processo_seletivo_onfly/app_widget.dart';

import 'detect_memory_leaks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  final memory = DetectMemoryLeaks();
  WidgetsBinding.instance.addObserver(memory);
  await dotenv.load(fileName: '.env');
  runApp(const AppWidget());
}