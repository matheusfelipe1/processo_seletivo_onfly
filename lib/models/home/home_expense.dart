import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/core/provider/cached/custom_cached.dart';
import 'package:processo_seletivo_onfly/core/repositories/home/home_repository.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';

import '../../core/events/expense_events.dart';

class HomeExpenseModel {
  List<ExpenseModel>? list;
  List<ExpenseModel>? listCached;
  final NumberFormat format =
      NumberFormat.currency(locale: 'en_US', symbol: 'R\$ ');
  final DateFormat formatDate = DateFormat('yyyy/MM/dd');
  final DateFormat formatTime = DateFormat('HH:mm');
  final _repository = HomeRepository();

  HomeExpenseModel({this.list, this.listCached}) {
    _repository.notifyEvents = _onNotifyEvent;
  }

  Function(List<ExpenseModel>)? notifyList;

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

  void onDeleteExpense(String id) async {
    await _repository.delete(id);
  }

  void _onNotifyEvent(ExpenseEvents event, [String? id]) {
    switch (event.runtimeType) {
      case ExpenseDelete:
        final list = [...listCached!]
          ..removeWhere((element) => element.id == id);
        onReceivedNewList = list;
        CustomCachedManager.put(VariablesStatic.expenseList, list);
        notifyList?.call(list);
      default:
    }
  }
}
