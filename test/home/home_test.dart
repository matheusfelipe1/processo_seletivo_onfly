import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:processo_seletivo_onfly/core/middleware/custom_http.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/provider_controller.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_paths.dart';
import 'package:processo_seletivo_onfly/shared/routes/app_routes.dart';
import 'package:processo_seletivo_onfly/shared/static/endpoints.dart';
import 'package:processo_seletivo_onfly/viewmodels/details_viewmodel.dart';
import 'package:processo_seletivo_onfly/viewmodels/home_viewmodel.dart';

class MockDio extends Mock implements CustomHttp {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HomeViewModel home;
  late DetailsViewModel details;
  setUp(() {
    Get.testMode = true;
    home = HomeViewModel();
    details = DetailsViewModel(null);
    Get.put<HomeViewModel>(home);
  });

  tearDown(() {
    Get.delete<HomeViewModel>();
  });

  // test('Integration test', () async {
  //   final mockDio = MockDio();
  //   await dotenv.load(fileName: '.env');
  //   when(await mockDio.client.get(Endpoints.expense))
  //       .thenAnswer((Invocation data) => Response<dynamic>(body: data., statusCode: 200,));
  // });
  testWidgets('Test Home Screen', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(GetMaterialApp(
      title: 'OnFly',
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [mockObserver],
      theme: ThemeData.dark(),
      getPages: AppRoutes.pages,
      initialRoute: AppPaths.home,
      onReady: () {
        ProividerController();
      },
    ));
    Get.put<HomeViewModel>(HomeViewModel());
    final viewModel = Get.find<HomeViewModel>();
    await tester.pumpAndSettle();

    expect(viewModel.expensesList.length, 0);

    await tester.pumpAndSettle();

    expect(viewModel.total.value, '\$ 0.00');

    await tester.pumpAndSettle();

    final textFormField = find.byType(TextFormField);

    expect(textFormField, findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Nobody expenses was founded'), findsOneWidget);


    final floatingActionButton = find.byType(FloatingActionButton);

    expect(floatingActionButton, findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));

    Get.put<DetailsViewModel>(details);

    await tester.pumpAndSettle();

    await tester.pumpAndSettle();

    expect(mockObserver.navigations.length, 2);

  });
}


class MockNavigatorObserver extends NavigatorObserver {
  // Lista para registrar as chamadas de navegação
  final List<Route<dynamic>> navigations = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Registre a chamada de navegação quando uma tela é empilhada
    navigations.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Registre a chamada de navegação quando uma tela é removida da pilha
    navigations.remove(route);
  }
}

