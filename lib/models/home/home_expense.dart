import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

class HomeExpenseModel {
  List<ExpenseModel>? list;
  List<ExpenseModel>? listCached;
  final NumberFormat format =
      NumberFormat.currency(locale: 'en_US', symbol: 'R\$ ');
  final DateFormat formatDate = DateFormat('yyyy/MM/dd');
  final DateFormat formatTime = DateFormat('HH:mm');

  HomeExpenseModel({this.list, this.listCached});

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
}
