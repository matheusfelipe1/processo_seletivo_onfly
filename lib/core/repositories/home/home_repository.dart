import 'package:flutter/cupertino.dart';
import 'package:processo_seletivo_onfly/core/events/expense_events.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';

import 'package:processo_seletivo_onfly/core/provider/databases/local_storage.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';

import '../../../models/expense/expense_model.dart';
import '../../../shared/enum/card_enum.dart';
import '../../../shared/static/endpoints.dart';
import '../../../shared/static/variables_static.dart';
import '../../provider/cached/custom_cached.dart';
import 'ihome_repository.dart';

class HomeRepository implements IHomeRepository {
  @override
  Function(List<ExpenseModel>)? notifyExecutedAction;

  @override
  DataSource get dataSource => DataSource();

  @override
  Future<void> getAll() async {
    List<ExpenseModel> values = [];
    try {
      final cacheList = CustomCachedManager.get(VariablesStatic.expenseList);
      if (cacheList.isNotEmpty) {
        values = [...cacheList.map((e) => e)];
      } else {
        final data = await dataSource.get(Endpoints.expense);
        final list = data["items"];
        if (list is List) {
          if (list.isNotEmpty) {
            if (list.hasOnlyOne) {
              final Map<String, dynamic> map = {};
              map.addAll(list.first);
              map.addAll({'typeCard': TypeCardEnum.date});
              list.insert(0, map);
              list[1]['typeCard'] = TypeCardEnum.task;
            }
            values = list
                .cast<Map<String, dynamic>>()
                .map(ExpenseModel.fromJSON)
                .toList();
            CustomCachedManager.put(VariablesStatic.expenseList, values);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyExecutedAction?.call(values);
    }
  }

  @override
  LocalStorage get localStorage => LocalStorage();
  
  @override
  Future<void> delete(String id) async {
    await dataSource.delete('${Endpoints.expense}/$id');
    notifyEvents?.call(ExpenseDelete(), id);
  }
  
  @override
  Function(ExpenseEvents p1, [String? id])? notifyEvents;


}
