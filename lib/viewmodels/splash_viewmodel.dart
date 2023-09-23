import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:processo_seletivo_onfly/core/events/navigation_event.dart';
import 'package:processo_seletivo_onfly/core/provider/auth/auth_controller.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_paths.dart';


class SplashViewModel extends GetxController {

  late AnimationController controller;
  late Animation<Offset> animate;
  final auth = AuthController();

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
        auth.onReceivedEvent(NavigationToHome());
      }
    });
  } 
}