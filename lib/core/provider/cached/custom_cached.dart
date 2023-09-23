import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

class CustomCachedManager {
  static Set<Map> datas = {};

  static Set get<T>(String key) {
    return datas.where((element) => element['key'] == key).toSet();
  }

  static void post(String key, List<ExpenseModel> list) {
    datas.add({'key': key, 'data': list});
  }

  static void put(String key, List<ExpenseModel> list) {
    datas.removeWhere((element) => element['key'] == key);
    datas.add({'key': key, 'data': list});
  }
}