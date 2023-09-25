
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/provider_controller.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_paths.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_routes.dart';
import 'package:processo_seletivo_onfly/viewmodels/details_viewmodel.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();
  late DetailsViewModel details;
  setUp(() {
    Get.testMode = true;
    details = DetailsViewModel(null);
    Get.put<DetailsViewModel>(details);
  });

  tearDown(() {
    Get.delete<DetailsViewModel>();
  });
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final widget = GetMaterialApp(
      title: 'OnFly',
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      getPages: AppRoutes.pages,
      initialRoute: AppPaths.details,
      onReady: () {
        ProividerController();
      },
    );

    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    expect(find.text("New expense"), findsOneWidget);
    expect(find.text("Description"), findsOneWidget);
    expect(find.text("Amount"), findsOneWidget);
    expect(find.text("Date"), findsOneWidget);
    expect(find.text("Time"), findsOneWidget);

  });
}
