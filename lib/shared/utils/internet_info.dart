import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/provider/controllers/provider_controller.dart';
import '../enum/state_internet_connection.dart';

class InternetInfo {
  static StateInternetConnection status = StateInternetConnection.unShow;
  static Function()? syncronizeDatas;
  static void get showNoInternet => status == StateInternetConnection.unShow || status == StateInternetConnection.canSync
      ? {removeSnackbar, ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "No internet",
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 18, color: Colors.white),
                ),
                Icon(Icons.wifi_off)
              ],
            ),
          ),
          actionOverflowThreshold: .8,
          elevation: 10.0,
          onVisible: () => status = StateInternetConnection.show,
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.black.withOpacity(.7),
          duration: const Duration(days: 3),
        ))}
      : null;

  static void get showHasIntent => status == StateInternetConnection.show
      ? {
          removeSnackbar,
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(Get.context!).size.width * .7),
                    child: const Text(
                      "Now you can synchronize the data with the database",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      removeSnackbar;
                      syncronizeDatas?.call();
                    },
                    icon: const Icon(Icons.sync),
                  )
                ],
              ),
            ),
            actionOverflowThreshold: .8,
            elevation: 10.0,
            onVisible: () => {status = StateInternetConnection.canSync, ProividerController()..doAuthenticate()},
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Colors.black.withOpacity(.7),
            duration: const Duration(days: 3),
          ))
        }
      : null;

  static void get removeSnackbar => status == StateInternetConnection.show ||
          status == StateInternetConnection.canSync
      ? {
          ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar(),
          status = StateInternetConnection.unShow,
        }
      : null;
}
