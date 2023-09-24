import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/provider_controller.dart';

import '../models/expense/expense_model.dart';
import '../models/home/home_expense.dart';
import '../shared/enum/states_enum.dart';

class HomeViewModel extends GetxController {
  final provider= ProividerController();
  final _model = HomeExpenseModel();

  RxList<ExpenseModel> expensesList = <ExpenseModel>[].obs;
  Rx<StateScreen> state = StateScreen.waiting.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    provider.onDispatchExpenses = (List<ExpenseModel> expenses) =>
        {_onReceivedDatas(expenses), _model.onReceivedNewList = expenses};
    _model.notifyList = _onReceivedDatas;
    provider.callDispose = _updateContext;
    _model.stateScreen= _onNotifyState;
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

  void delete(String id) {
    _model.onDeleteExpense(id);
  }

  Function()? updateContext;

  void _updateContext() {
    updateContext?.call();
  }

  void getAll([bool force = false]) {
    _model.getAll(force);
  }
}
