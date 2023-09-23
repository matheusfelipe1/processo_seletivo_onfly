import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/provider/auth/auth_controller.dart';

import '../models/expense/expense_model.dart';
import '../shared/enum/states_enum.dart';

class HomeViewModel extends GetxController {

  final auth = AuthController();
  RxList<ExpenseModel> expensesList = <ExpenseModel>[].obs;
  Rx<StateScreen> state = StateScreen.waiting.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    auth.onDispatchExpenses = _onReceivedDatas;
  }

  void _onReceivedDatas(List<ExpenseModel> expenses) {
    expensesList.value = expenses;
    _onNotifyState(expenses.isEmpty ? StateScreen.noHasData : StateScreen.hasData);
  }

  void _onNotifyState(StateScreen newState) {
    state.value = newState;
  }
}