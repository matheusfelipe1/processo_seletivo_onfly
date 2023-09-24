import 'dart:io';

import 'package:flutter/material.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../models/expense/expense_model.dart';
import '../../events/database_events.dart';

class InternalDatabase {
  static final InternalDatabase _instance = InternalDatabase._();
  InternalDatabase._() {
    _onInit();
  }
  factory InternalDatabase() => _instance;

  static final InternalDatabase instance = InternalDatabase();

  late String databasesPath;
  late String path;

  _onInit() async {
    databasesPath = await getDatabasesPath();
    path = join(databasesPath, VariablesStatic.dbName);
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  initialize() async => await _onInit();

  Future<Database> _getDatabase() async {
    return await openDatabase(path,
        onConfigure: _onConfigure,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen,
        onCreate: _onCreate,
        version: 10);
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

  Future<Map<String, Object?>?> getUniqueData(String query) async {
    Map<String, Object?>? datas = {};
    try {
      final database = await this.database;
      if (database.isOpen) {
        datas = (await database.query(VariablesStatic.expensesTable,
                where: 'idExpense = ?', whereArgs: [query]))
            .firstOrNull;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // ignore: control_flow_in_finally
      return datas;
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
        final data = await getUniqueData(row['idExpense'] as String);
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
        await database.insert(VariablesStatic.expensesTable, row);
        success = true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // ignore: control_flow_in_finally
      return success;
    }
  }

  Future<dynamic> executeActions<T>(DatabaseEvent event,
      [ExpenseModel? query]) async {
    switch (event.runtimeType) {
      case DatabaseAdded when query.runtimeType == ExpenseModel:
        final Map<String, Object?> data = {
          'idExpense': null,
          'description': query!.description,
          'expense_date': query.expenseDate,
          'amount': query.amount,
          'typeEvent': 'DatabaseAdded',
        };
        await insertData(data);
        break;
      case DatabaseUpdate when query.runtimeType == ExpenseModel:
        final Map<String, Object?> data = {
          'idExpense': query!.id,
          'description': query.description,
          'expense_date': query.expenseDate,
          'amount': query.amount,
          'typeEvent': 'DatabaseUpdate',
        };
        await insertData(data);
        break;
      case DatabaseRemoved when query.runtimeType == ExpenseModel:
        final Map<String, Object?> data = {
          'idExpense': query!.id,
          'description': query.description,
          'expense_date': query.expenseDate,
          'amount': query.amount,
          'typeEvent': 'DatabaseRemoved',
        };
        await insertData(data);
        break;

      case DatabaseRemovedAll:
        await removeAllData();
        break;
      case DatabaseGetAll:
        List<(ExpenseModel, DatabaseEvent)> list = [];
        final listData = await getAllData();
        list = listData
            .cast<Map<String, dynamic>>()
            .map((e) => (ExpenseModel(
                amount: e['amount'],
                description: e['description'],
                expenseDate: e['expense_date'],
                id: e['idExpense']), typeEvent(e['typeEvent']) ))
            .toList();
        return list;
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
}
