import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';
import 'package:processo_seletivo_onfly/core/provider/cached/custom_cached.dart';
import 'package:processo_seletivo_onfly/core/provider/databases/local_storage.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';
import 'package:processo_seletivo_onfly/shared/enum/card_enum.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';
import 'package:processo_seletivo_onfly/shared/static/endpoints.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';

import 'iprovider_repository.dart';

class ProviderRepository implements IProviderRepository {
  @override
  // TODO: implement dataSource
  DataSource get dataSource => DataSource();

  @override
  Future<void> doAuthenticate() async {
    try {
      final result = await dataSource.post(Endpoints.authenticate,
          {"identity": dotenv.get('LOGIN'), "password": dotenv.get('SENHA')});
      localStorage.onSave(VariablesStatic.TOKEN, result[VariablesStatic.TOKEN]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyExecutedAction?.call(null);
      getAll();
    }
  }

  @override
  // TODO: implement localStorage
  LocalStorage get localStorage => LocalStorage();

  @override
  Function(dynamic)? notifyExecutedAction;

  @override
  Future<void> getAll() async {
    List<ExpenseModel> values = [];
    try {
      final data = await dataSource.get(Endpoints.expense);
      final list = data["items"];
      if (list is List) {
        if (list.isNotEmpty) {
          list.sort((a, b) => b['expense_date'].toString().toDate.compareTo(a['expense_date'].toString().toDate));
          values = list
              .cast<Map<String, dynamic>>()
              .map(ExpenseModel.fromJSON)
              .toList();
          CustomCachedManager.post(VariablesStatic.expenseList, values);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      notifyExecutedAction?.call(values);
    }
  }
}
