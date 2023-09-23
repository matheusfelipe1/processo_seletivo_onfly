import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/provider/auth/auth_controller.dart';

import '../models/expense/expense_model.dart';
import '../models/home/home_expense.dart';
import '../shared/enum/states_enum.dart';

class HomeViewModel extends GetxController {
  final auth = AuthController();
  final _model = HomeExpenseModel();

  RxList<ExpenseModel> expensesList = <ExpenseModel>[].obs;
  Rx<StateScreen> state = StateScreen.waiting.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    auth.onDispatchExpenses = (List<ExpenseModel> expenses) =>
        {_onReceivedDatas(expenses), _model.onReceivedNewList = expenses};
    _model.notifyList = _onReceivedDatas;
  }

  void _onReceivedDatas(List<ExpenseModel> expenses) {
    expensesList.value = expenses;
    _onNotifyState(
        expenses.isEmpty ? StateScreen.noHasData : StateScreen.hasData);
  }

  void _onNotifyState(StateScreen newState) {
    state.value = newState;
  }

  void onFiltering(String query) {
    _model.onFilter(query.toLowerCase());
  }
}
