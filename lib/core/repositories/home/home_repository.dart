import 'package:flutter/cupertino.dart';
import 'package:processo_seletivo_onfly/core/events/expense_events.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';

import 'package:processo_seletivo_onfly/core/provider/databases/local_storage.dart';
import 'package:processo_seletivo_onfly/shared/enum/states_enum.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';

import '../../../models/expense/expense_model.dart';
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
  Future<void> getAll([bool force = false]) async {
    stateScreen?.call(StateScreen.waiting);
    List<ExpenseModel> values = [];
    try {
      final cacheList = CustomCachedManager.get(VariablesStatic.expenseList);
      if (cacheList.any((element) =>
              element['key'] == VariablesStatic.expenseList &&
              element['data'] is List &&
              element['data'].isNotEmpty) &&
          !force) {
        values = (cacheList.firstWhere((element) =>
            element['key'] == VariablesStatic.expenseList))['data'];
      } else {
        stateScreen?.call(StateScreen.waiting);
        final data = await dataSource.get(Endpoints.expense);
        final list = data["items"];
        if (list is List) {
          if (list.isNotEmpty) {
            list.sort((a, b) => b['expense_date']
                .toString()
                .toDate
                .compareTo(a['expense_date'].toString().toDate));
            values = list
                .cast<Map<String, dynamic>>()
                .map(ExpenseModel.fromJSON)
                .toList();
            CustomCachedManager.post(VariablesStatic.expenseList, values);
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      stateScreen?.call(StateScreen.hasData);
    } finally {
      stateScreen?.call(StateScreen.hasData);
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

  @override
  Function(StateScreen newState)? stateScreen;
}
