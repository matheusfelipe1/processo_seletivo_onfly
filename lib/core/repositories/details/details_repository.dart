import 'package:flutter/cupertino.dart';
import 'package:processo_seletivo_onfly/core/events/expense_events.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';
import 'package:processo_seletivo_onfly/core/provider/databases/internal_database.dart';
import 'package:processo_seletivo_onfly/core/repositories/details/idetails_repository.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';
import 'package:processo_seletivo_onfly/shared/enum/states_enum.dart';
import 'package:processo_seletivo_onfly/shared/static/endpoints.dart';

import '../../../shared/utils/inform_no_internet.dart';
import '../../events/database_events.dart';

class DetailsRepository implements IDetailsRepository {
  @override
  Function(StateScreen p1)? statePage;

  @override
  // TODO: implement dataSource
  DataSource get dataSource => DataSource();

  @override
  Future<void> getUniqueData(String id) async {
    var state = StateScreen.waiting;
    try {
      statePage?.call(state);
      final data = await dataSource.get('${Endpoints.expense}/$id');
      dispatchValue?.call((ExpenseModel.fromJSON(data), ExpenseUniqueData()));
      state = StateScreen.hasData;
    } catch (e) {
      state = StateScreen.noHasData;
      debugPrint(e.toString());
    } finally {
      statePage?.call(state);
    }
  }

  @override
  Future<void> register(Map body) async {
    var state = StateScreen.waiting;
    try {
      statePage?.call(state);
      final data = await dataSource.post(Endpoints.expense, body);
      dispatchValue?.call((ExpenseModel.fromJSON(data), ExpenseAdded()));
      state = StateScreen.hasData;
    } catch (e) {
      state = StateScreen.hasData;
      debugPrint(e.toString());
      final value = ExpenseModel(
          description: body['description'],
          expenseDate: body['expense_date'],
          amount: body['amount']);
      dispatchValue?.call((value, ExpenseAdded()));
      database.executeActions(DatabaseAdded(), value);
      statePage?.call(state);
      InformNoIntenet.showMessageInternalDatabase();
    } finally {
      statePage?.call(state);
    }
  }

  @override
  Future<void> update(String id, Map body) async {
    var state = StateScreen.waiting;
    try {
      statePage?.call(StateScreen.waiting);
      final data = await dataSource.patch('${Endpoints.expense}/$id', body);
      dispatchValue?.call((ExpenseModel.fromJSON(data), ExpenseUpdate()));
      state = StateScreen.hasData;
    } catch (e) {
      debugPrint(e.toString());
      state = StateScreen.hasData;
      final value = ExpenseModel(
          id: id,
          description: body['description'],
          expenseDate: body['expense_date'],
          amount: body['amount']);
      dispatchValue?.call((value, ExpenseAdded()));
      database.executeActions(DatabaseUpdate(), value);
      statePage?.call(state);
      InformNoIntenet.showMessageInternalDatabase();
    } finally {
      statePage?.call(state);
    }
  }

  @override
  Function((ExpenseModel p1, ExpenseEvents p2))? dispatchValue;

  @override
  // TODO: implement database
  InternalDatabase get database => InternalDatabase.instance;
}
