import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

class CustomCachedManager {
  static Set<List<ExpenseModel>> datas = {};

  static List<ExpenseModel> getDatas() {
    final List<ExpenseModel> values = [];
    datas.map((e) => values.addAll(e));
    return values;
  }

  static setDatas(List<ExpenseModel> list) {
    datas.add(list);
  }
}