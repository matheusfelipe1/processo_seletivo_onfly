import 'package:flutter/material.dart';

class DetectMemoryLeaks extends WidgetsBindingObserver {
  @override
  void didHaveMemoryPressure() {
    debugPrint('We had a memory leak');
    super.didHaveMemoryPressure();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    debugPrint(state.toString());
  }
}