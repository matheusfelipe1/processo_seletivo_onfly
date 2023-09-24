import '../../models/expense/expense_model.dart';

extension CustomList<T> on List {
  bool _even() {
    return length % 2 == 0;
  }

  bool _onlyOneElement() {
    return length == 1;
  }

  bool get isEvent => _even();
  bool get hasOnlyOne => _onlyOneElement();
}

extension CustomData<T> on String {
  DateTime get toDateTime {
    return DateTime.parse(replaceAll('/', '-'));
  }

  DateTime get toDate {
    return DateTime.parse(this);
  }

  String get onlyDate {
    final listStrings = split('');
    var index;
    if (contains('T')) {
      index = listStrings.indexOf('T');
    } else {
      index = listStrings.indexOf(' ');
    }
    final range = listStrings.getRange(0, index);
    return range.join('');
  }
}

extension CustomDatas on List<ExpenseModel> {
  bool showDateHere(int index) {
    final currentElement = this[index];
    if (index == 0) return false;
    final beforeElement = this[index - 1];
    if (beforeElement.expenseDate
            .toString()
            .onlyDate
            .toDate
            .difference(currentElement.expenseDate.toString().onlyDate.toDate)
            .inDays >
        0) return true;
    return false;
  }

  void addWhere(ExpenseModel item) {
    removeWhere((element) => element.id == item.id);
    final index = indexWhere((element) => item.expenseDate
        .toString()
        .toDate
        .isAfter(element.expenseDate.toString().toDate));
    if (index == -1) {
      add(item);
    } else {
      insert(index, item);}
  }
}
