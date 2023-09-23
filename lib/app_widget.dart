import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_routes.dart';
import 'package:processo_seletivo_onfly/views/home_view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'OnFly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      getPages: AppRoutes.pages,
      home: HomeView(),
    );
  }
}