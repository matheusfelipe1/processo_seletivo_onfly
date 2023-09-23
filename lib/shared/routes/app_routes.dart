import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_paths.dart';
import 'package:processo_seletivo_onfly/views/details_view.dart';
import 'package:processo_seletivo_onfly/views/home_view.dart';
import 'package:processo_seletivo_onfly/views/splash_view.dart';

class AppRoutes {
  static List<GetPage> get pages => [
    GetPage(name: AppPaths.splash, page: () => const SplashView()),
    GetPage(name: AppPaths.home, page: () => const HomeView()),
    GetPage(name: AppPaths.details, page: () => DetailsView(id: Get.arguments,)),
  ];
}