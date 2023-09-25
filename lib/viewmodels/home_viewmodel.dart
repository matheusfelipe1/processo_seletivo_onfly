import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/provider_controller.dart';

import '../models/expense/expense_model.dart';
import '../models/home/home_expense.dart';
import '../shared/enum/states_enum.dart';

class HomeViewModel extends GetxController {
  final provider= ProividerController();
  final _model = HomeExpenseModel();

  RxList<ExpenseModel> expensesList = <ExpenseModel>[].obs;
  Rx<StateScreen> state = StateScreen.waiting.obs;
  RxString total = '0.0'.obs;
  final format = NumberFormat.currency(locale: 'en_US', decimalDigits: 2, symbol: '\$ ');

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
    if (expenses.isNotEmpty) {
      final totalCounted = expenses.map((e) => e.amount!).reduce((a, b) => a + b);
      total.value = format.format(totalCounted);
    } else {
      total.value = format.format(0);
    }
    _onNotifyState(
        expenses.isEmpty ? StateScreen.noHasData : StateScreen.hasData);
  }

  void _onNotifyState(StateScreen newState) {
    state.value = newState;
  }

  void onFiltering(String query) {
    _model.onFilter(query.toLowerCase());
  }

  void delete(String id, ExpenseModel model) {
    _model.onDeleteExpense(id, model);
  }

  Function()? updateContext;

  void _updateContext() {
    updateContext?.call();
  }

  void getAll([bool force = false]) {
    _model.getAll(force);
  }

  void executeSync() {
    provider.executeDataProcessingFromAlert();
  }
}
