
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
  testWidgets('Test Details Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final widget = await tester.pumpWidget(GetMaterialApp(
      title: 'OnFly',
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      getPages: AppRoutes.pages,
      initialRoute: AppPaths.details,
      onReady: () {
        ProividerController();
      },
    ));

    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    expect(find.text("New expense"), findsOneWidget);
    expect(find.text("Description"), findsOneWidget);
    expect(find.text("Amount"), findsOneWidget);
    expect(find.text("Date"), findsOneWidget);
    expect(find.text("Time"), findsOneWidget);

    details.description.text = 'teste ';
    details.amount.text = '0.0 ';
    details.date.text = '2023-09-25 ' ;
    details.time.text = '17: ';

    final inkwell = find.byType(InkWell);

    expect(inkwell, findsNWidgets(2));

    details.validForm.value = true;

    final textForm = find.byType(TextFormField);

    expect(textForm, findsNWidgets(4));

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);


    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('Invalid time.'), findsOneWidget);
    // this should be invalid because time is incorrect.

    details.description.text = '  ';
    details.amount.text = '0.0 ';
    details.date.text = '2023-09-25 ' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);


    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('This field cannot be empty'), findsOneWidget);

    details.description.text = 'Pizza';
    details.amount.text = 'abc';
    details.date.text = '2023-09-25' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);


    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('Invalid amount'), findsOneWidget);

    details.description.text = 'Pizza';
    details.amount.text = '10.0';
    details.date.text = '2023-09-25' ;
    details.time.text = '17: ';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);

    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('Invalid time.'), findsOneWidget);

    details.description.text = 'Pizza';
    details.amount.text = '0.0';
    details.date.text = '2023-09-25' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);

    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('Amount cannot be \$ 0.0'), findsOneWidget);


    details.description.text = 'Pizza';
    details.amount.text = '50.0';
    details.date.text = '  ' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);

    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('This field cannot be empty'), findsOneWidget);

    details.description.text = 'Pizza';
    details.amount.text = '50.0';
    details.date.text = '  ' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);

    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('This field cannot be empty'), findsOneWidget);

    details.description.text = 'Pizza';
    details.amount.text = '50.0';
    details.date.text = '2023-09' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);

    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('Invalid date'), findsOneWidget);

    details.description.text = 'Pizza';
    details.amount.text = '50.0';
    details.date.text = '2023/09' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);

    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('Invalid date'), findsOneWidget);

    details.description.text = 'Pizza';
    details.amount.text = '50.0';
    details.date.text = 'abjhdj' ;
    details.time.text = '17:30';
    

    await tester.enterText(textForm.at(0), details.description.text);
    await tester.enterText(textForm.at(1), details.amount.text);
    await tester.enterText(textForm.at(2), details.date.text);
    await tester.enterText(textForm.at(3), details.time.text);

    await tester.tap(inkwell.at(1));

    await tester.pumpAndSettle();

    expect(find.text('Invalid date'), findsOneWidget);
  });
}
