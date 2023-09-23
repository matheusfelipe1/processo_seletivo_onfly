import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:processo_seletivo_onfly/core/provider/auth/auth_controller.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OnFly',
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      getPages: AppRoutes.pages,
      onInit: () => AuthController(),
    );
  }
}
