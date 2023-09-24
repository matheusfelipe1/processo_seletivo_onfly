import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:processo_seletivo_onfly/shared/static/app_colors.dart';

class Loading {
  static bool isShowing = false;
  static void show() => {
        isShowing = true,
        showCupertinoModalPopup(
            context: Get.context!,
            barrierDismissible: false,
            builder: (ctx) => Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                    color: AppColors.blue,
                    size: 70,
                  ),
                ))
      };

  static void hide() => {isShowing = false, Get.back()};
}
