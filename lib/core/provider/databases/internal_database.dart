import 'dart:io';

import 'package:flutter/material.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../models/expense/expense_model.dart';
import '../../../shared/enum/state_database.dart';
import '../../../shared/enum/status_request.dart';
import '../../events/database_events.dart';

class InternalDatabase {
  static final InternalDatabase _instance = InternalDatabase._();
  InternalDatabase._() {
    _onInit();
  }
  factory InternalDatabase() => _instance;

  static final InternalDatabase instance = InternalDatabase();

  Future<String> get databasesPath async => await getDatabasesPath();
  Future<String> get path async =>
      join(await databasesPath, VariablesStatic.dbName);

  StateDatabase status = StateDatabase.notProcessing;

  _onInit() async {
    try {
      await Directory(await databasesPath).create(recursive: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  initialize() async => await _onInit();

  Future<Database> _getDatabase() async {
    return await openDatabase(await path,
        onConfigure: _onConfigure,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen,
        onCreate: _onCreate,
        version: 12);
  }

  _onConfigure(Database db) async {
    await db.execute(VariablesStatic.expenses);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(VariablesStatic.expenses);
  }

  _onCreate(Database db, int versopm) async {
    await db.execute(VariablesStatic.expenses);
  }

  void _onOpen(Database db) async {
    await db.execute(VariablesStatic.expenses);
  }

  Future<Database> get database async => await _getDatabase();

  Future<List<Map<String, Object?>>> getAllData() async {
    List<Map<String, Object?>> datas = [];
    try {
      final database = await this.database;
      if (database.isOpen) {
        final list = await database.query(VariablesStatic.expensesTable);
        datas = list;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // ignore: control_flow_in_finally
      return datas;
    }
  }

  Future<Map<String, Object?>?> getUniqueData(
      String where, List<dynamic> queries) async {
    Map<String, Object?>? datas = {};
    try {
      final database = await this.database;
      if (database.isOpen) {
        datas = (await database.query(VariablesStatic.expensesTable,
                where: where, whereArgs: queries))
            .firstOrNull;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // ignore: control_flow_in_finally
      return datas;
    }
  }

  Future<void> removeUniqueData(String query) async {
    try {
      final database = await this.database;
      if (database.isOpen) {
        await database.delete(VariablesStatic.expensesTable,
            where: 'idExpense = ?', whereArgs: [query]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeUniqueDataOnlyDatabase(
      String columns, List<dynamic> values) async {
    try {
      final database = await this.database;
      if (database.isOpen) {
        await database.delete(VariablesStatic.expensesTable,
            where: columns, whereArgs: values);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeAllData() async {
    try {
      final database = await this.database;
      if (database.isOpen) {
        await database.delete(VariablesStatic.expensesTable);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> insertData(Map<String, Object?> row) async {
    bool success = false;
    try {
      if (row['idExpense'] != null) {
        final data =
            await getUniqueData('idExpense = ?', [row['idExpense'] as String]);
        if (data != null && data.isNotEmpty) {
          final database = await this.database;
          await database.update(VariablesStatic.expensesTable, row,
              where: 'idExpense = ?', whereArgs: [row['idExpense'] as String]);
          success = true;
        } else {
          final database = await this.database;
          await database.insert(VariablesStatic.expensesTable, row);
          success = true;
        }
      } else {
        final database = await this.database;
        final data = await getUniqueData(
            'description = ? AND expense_date = ? AND amount = ?', [
          row['description'] as String,
          row['expense_date'] as String,
          row['amount'] as double
        ]);
        if (data != null && data.isNotEmpty) {
          await database.update(VariablesStatic.expensesTable, row,
              where: 'description = ? AND expense_date = ? AND amount = ?',
              whereArgs: [
                row['description'] as String,
                row['expense_date'] as String,
                row['amount'] as double
              ]);
          success = true;
        } else {
          await database.insert(VariablesStatic.expensesTable, row);
          success = true;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // ignore: control_flow_in_finally
      return success;
    }
  }

  Future<dynamic> executeActions<T>(DatabaseEvent event,
      [dynamic query, StatusRequest? statusRequest]) async {
    switch (event.runtimeType) {
      case DatabaseAdded when query.runtimeType == ExpenseModel:
        final Map<String, Object?> data = {
          'idExpense': null,
          'description': query!.description,
          'expense_date': query.expenseDate,
          'amount': query.amount,
          'typeEvent': 'DatabaseAdded',
          'notSynchronized': query.notSynchronized == true ? 1 : 0
        };
        await insertData(data);
        break;
      case DatabaseAddedAll when query.runtimeType == List<ExpenseModel>:
        final listData = await getAllData();
        for (var item in query) {
          final Map<String, Object?> data = {
            'idExpense': item.id,
            'description': item.description,
            'expense_date': item.expenseDate,
            'amount': item.amount,
            'typeEvent': 'DatabaseAdded',
            'notSynchronized': item.notSynchronized == true ? 1 : 0
          };
          if (status == StateDatabase.notProcessing && listData.isEmpty) {
            await insertData(data);
          }
        }
        status = StateDatabase.alreadyProcessing;
        break;
      case DatabaseUpdate when query.runtimeType == ExpenseModel:
        final Map<String, Object?> data = {
          'idExpense': query!.id,
          'description': query.description,
          'expense_date': query.expenseDate,
          'amount': query.amount,
          'typeEvent': 'DatabaseUpdate',
          'notSynchronized': query.notSynchronized == true ? 1 : 0
        };
        await insertData(data);
        break;
      case DatabaseRemoved
          when query.runtimeType == ExpenseModel &&
              statusRequest == StatusRequest.failure:
        final Map<String, Object?> data = {
          'idExpense': query!.id,
          'description': query.description,
          'expense_date': query.expenseDate,
          'amount': query.amount,
          'typeEvent': 'DatabaseRemoved',
          'notSynchronized': query.notSynchronized == true ? 1 : 0
        };
        await insertData(data);
        break;
      case DatabaseRemoved
          when query.runtimeType == ExpenseModel &&
              statusRequest == StatusRequest.success:
        await removeUniqueData(query.id);
        break;
      case DatabaseRemovedDatabase
          when query.runtimeType == ExpenseModel &&
              statusRequest == StatusRequest.success:
        await removeUniqueDataOnlyDatabase(
            'description = ? AND expense_date = ? AND amount = ?',
            [query.description, query.expenseDate, query.amount]);
        break;
      case DatabaseRemovedAll:
        await removeAllData();
        status = StateDatabase.notProcessing;
        break;
      case DatabaseGetAll:
        List<(ExpenseModel, DatabaseEvent)> list = [];
        final listData = await getAllData();
        list = listData
            .cast<Map<String, dynamic>>()
            .map((e) => (
                  ExpenseModel(
                      amount: e['amount'],
                      description: e['description'],
                      expenseDate: e['expense_date'],
                      notSynchronized: e['notSynchronized'] == 1 ? true : false,
                      id: e['idExpense']),
                  typeEvent(e['typeEvent'])
                ))
            .toList();
        return list;
      case DatabaseUpdateSync when query.runtimeType == ExpenseModel:
        final Map<String, Object?> data = {
          'idExpense': null,
          'description': query!.description,
          'expense_date': query.expenseDate,
          'amount': query.amount,
          'typeEvent': query.runtimeType.toString(),
          'notSynchronized': 0
        };
        await updateSync(data);
        break;
      default:
    }
  }

  DatabaseEvent typeEvent(String query) {
    switch (query) {
      case 'DatabaseRemoved':
        return DatabaseRemoved();
      case 'DatabaseUpdate':
        return DatabaseUpdate();
      default:
        return DatabaseAdded();
    }
  }

  Future<bool> updateSync(Map<String, Object?> row) async {
    bool success = false;
    try {
      if (row['idExpense'] != null) {
        final data =
            await getUniqueData('idExpense = ?', [row['idExpense'] as String]);
        if (data != null && data.isNotEmpty) {
          final database = await this.database;
          await database.update(VariablesStatic.expensesTable, row,
              where: 'idExpense = ?', whereArgs: [row['idExpense'] as String]);
          success = true;
        } else {
          success = false;
        }
      } else {
        final database = await this.database;
        final data = await getUniqueData(
            'description = ? AND expense_date = ? AND amount = ?', [
          row['description'] as String,
          row['expense_date'] as String,
          row['amount'] as double
        ]);
        if (data != null && data.isNotEmpty) {
          await database.update(VariablesStatic.expensesTable, row,
              where: 'description = ? AND expense_date = ? AND amount = ?',
              whereArgs: [
                row['description'] as String,
                row['expense_date'] as String,
                row['amount'] as double
              ]);
          success = true;
        } else {
          success = false;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // ignore: control_flow_in_finally
      return success;
    }
  }
}
