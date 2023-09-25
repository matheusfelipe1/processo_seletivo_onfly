import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/core/provider/cached/custom_cached.dart';
import 'package:processo_seletivo_onfly/core/repositories/home/home_repository.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';

import '../../core/events/expense_events.dart';
import '../../core/provider/controllers/provider_controller.dart';
import '../../shared/enum/states_enum.dart';

class HomeExpenseModel {
  List<ExpenseModel>? list;
  List<ExpenseModel>? listCached;
  final NumberFormat format =
      NumberFormat.currency(locale: 'en_US', symbol: 'R\$ ');
  final DateFormat formatDate = DateFormat('yyyy/MM/dd');
  final DateFormat formatTime = DateFormat('HH:mm');
  final _repository = HomeRepository();
  final _provider = ProividerController();

  HomeExpenseModel({this.list, this.listCached}) {
    _repository.notifyEvents = _onNotifyEvent;
    _repository.notifyExecutedAction = _provider.onReceivedEvent;
    _repository.stateScreen = (p0) => stateScreen?.call(p0);
  }

  Function(List<ExpenseModel>)? notifyList;

  Function(StateScreen newState)? stateScreen;

  void onFilter(String query) {
    final newList = listCached!
        .where((element) =>
            format.format(element.amount).toString().contains(query) ||
            (element.description?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            formatDate
                .format(DateTime.parse(element.expenseDate!))
                .contains(query) ||
            formatTime
                .format(DateTime.parse(element.expenseDate!))
                .contains(query))
        .toList();
    list = newList;
    notifyList?.call(newList);
  }

  set onReceivedNewList(List<ExpenseModel> newList) =>
      {list = newList, listCached = newList};

  void onDeleteExpense(String id, ExpenseModel model) async {
    await _repository.delete(id, model);
  }

  void _onNotifyEvent(ExpenseEvents event, [String? id, ExpenseModel? model]) {
    switch (event.runtimeType) {
      case ExpenseDelete:
        final list = [...listCached!]
          ..removeWhere((element) => element == model);
        final element = model;
        onReceivedNewList = list;
        CustomCachedManager.put(VariablesStatic.expenseList, list);
        notifyList?.call(list);
        _provider.onReceivedEvent(element, event);
      default:
    }
  }

  void getAll([bool force = false]) {
    _repository.getAll(force);
  }
}
