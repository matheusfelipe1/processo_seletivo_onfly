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

import 'iauth_repository.dart';

class AuthRepository implements IAuthRepository {
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
