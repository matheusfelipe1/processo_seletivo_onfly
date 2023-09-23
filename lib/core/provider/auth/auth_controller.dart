import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/events/navigation_event.dart';
import 'package:processo_seletivo_onfly/core/provider/auth/iauth_controller.dart';

import '../../../models/expense/expense_model.dart';
import '../../../shared/routes/app_paths.dart';

class AuthController extends IAuthController {
  static final AuthController _instance = AuthController._();
  AuthController._() {
    doAuthenticate();
  }
  factory AuthController() => _instance;

  @override
  void doAuthenticate() async {
    await auth.doAuthenticate();
    auth.notifyExecutedAction = onReceivedEvent;
  }

  @override
  onReceivedEvent(event) {
    switch (event.runtimeType) {
      case const (List<ExpenseModel>):
        expenses = event;
        onDispatchExpenses?.call(expenses);
        break;
      case NavigationToHome:
        Get.toNamed(AppPaths.home);
        break;
      default:
    }
  }
}
