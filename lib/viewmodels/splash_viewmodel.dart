import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:processo_seletivo_onfly/core/events/navigation_event.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/provider_controller.dart';

class SplashViewModel extends GetxController {

  late AnimationController controller;
  late Animation<Offset> animate;
  final provider= ProividerController();

  Function()? notifyAction;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  onAnimatedFinish() {
    controller.forward();
    controller.addListener(() {
      notifyAction?.call();
      if (animate.isCompleted) {
        provider.onReceivedEvent(NavigationToHome());
      }
    });
  } 
}