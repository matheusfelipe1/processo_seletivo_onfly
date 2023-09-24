import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/provider_controller.dart';
import 'package:processo_seletivo_onfly/shared/animations/animation_loading.dart';
import 'package:processo_seletivo_onfly/viewmodels/details_viewmodel.dart';
import 'package:processo_seletivo_onfly/viewmodels/home_viewmodel.dart';

import '../../core/events/navigation_event.dart';

class InformNoIntenet {
  static void show() {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: Get.context!,
        builder: (ctx) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(Get.context!).size.width * .6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text(
                        'You have not access internet in this moment, try later.',
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(Get.context!).size.width * .05,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        if (Loading.isShowing) {
                          Loading.hide();
                        }
                        Get.back();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
