import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/shared/animations/animation_loading.dart';

class InformNoIntenet {
  static void showMessageInternalDatabase() {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: Get.context!,
        builder: (ctx) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(Get.context!).size.width * .7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text(
                        'An error occurred when trying to save this data in the API, but rest assured as this data was saved in our internal database. Afterwards you will be synchronized with our API.',
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

  static void showMessageInternalDatabase2() {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: Get.context!,
        builder: (ctx) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(Get.context!).size.width * .7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text(
                        'An error occurred when trying to remove this data in the API, but rest assured as this action was saved in our internal database. Afterwards you will be synchronized with our API.',
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

  static void showMessageInternalDatabase3() {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: Get.context!,
        builder: (ctx) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(Get.context!).size.width * .7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text(
                        "You can't access the breakdown of an item that isn't synced.",
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

  static void showMessageInternalDatabase4() {
    showCupertinoModalPopup(
        barrierDismissible: false,
        context: Get.context!,
        builder: (ctx) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(Get.context!).size.width * .7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Text(
                        "You can't execute this action without internet.",
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
