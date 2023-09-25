import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:processo_seletivo_onfly/core/events/database_events.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';
import 'package:processo_seletivo_onfly/core/provider/cached/custom_cached.dart';
import 'package:processo_seletivo_onfly/core/provider/databases/local_storage.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';
import 'package:processo_seletivo_onfly/shared/static/endpoints.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';

import '../../../shared/enum/status_request.dart';
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
      // this is necessary for in the case that user has not intenet
      Future.delayed(const Duration(milliseconds: 3500), () {
        notifyExecutedAction?.call(null);
        getAll();
      });
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

  @override
  Future<List<(ExpenseModel, StatusRequest, DatabaseEvent)>> synchronize(List<(ExpenseModel, DatabaseEvent)> datas) async {
    final List<(ExpenseModel, StatusRequest, DatabaseEvent)> list = [];
    try {
      for (var element in datas) {
        switch (element.$2.runtimeType) {
          case DatabaseAdded:
            list.add((element.$1, await register(element.$1.toJSON), element.$2));
            break;
          case DatabaseUpdate:
            list.add((element.$1, await update(element.$1.id!, element.$1.toJSON), element.$2));
            break;
          case DatabaseRemoved:
            list.add((element.$1, await delete(element.$1.id!), element.$2));
            break;
          default:
        }
      }
      await getAll();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      return list;
    }
  }
  
  @override
  Future<StatusRequest> register(Map body) async {
    try {
      await dataSource.post(Endpoints.expense, body);
      return StatusRequest.success;
    } catch (e) {
      debugPrint(e.toString());
      return StatusRequest.failure;
    } 
  }

  @override
  Future<StatusRequest> update(String id, Map body) async {
    try {
      await dataSource.patch('${Endpoints.expense}/$id', body);
      return StatusRequest.success;
    } catch (e) {
      debugPrint(e.toString());
      return StatusRequest.failure;
    } 
  }
  
  @override
  Future<StatusRequest> delete(String id) async{
     try {
      await dataSource.delete('${Endpoints.expense}/$id');
      return StatusRequest.success;
    } catch (e) {
      debugPrint(e.toString());
      return StatusRequest.failure;
    }
  }
}
