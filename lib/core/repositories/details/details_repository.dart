import 'package:flutter/cupertino.dart';
import 'package:processo_seletivo_onfly/core/events/expense_events.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';
import 'package:processo_seletivo_onfly/core/repositories/details/idetails_repository.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';
import 'package:processo_seletivo_onfly/shared/enum/states_enum.dart';
import 'package:processo_seletivo_onfly/shared/static/endpoints.dart';

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
      dispatchValue?.call((
        ExpenseModel(
            description: body['description'],
            expenseDate: body['expense_date'],
            amount: body['amount']),
        ExpenseAdded()
      ));
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
      dispatchValue?.call((
        ExpenseModel(
            id: id,
            description: body['description'],
            expenseDate: body['expense_date'],
            amount: body['amount']),
        ExpenseAdded()
      ));
    } finally {
      statePage?.call(state);
    }
  }

  @override
  Function((ExpenseModel p1, ExpenseEvents p2))? dispatchValue;
}
