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
    statePage?.call(StateScreen.waiting);
    final data = await dataSource.get('${Endpoints.expense}/$id');
    dispatchValue?.call(ExpenseModel.fromJSON(data));
    statePage?.call(StateScreen.hasData);
  }

  @override
  Future<void> register(Map body) async {
    statePage?.call(StateScreen.waiting);
    final data = await dataSource.post(Endpoints.expense, body);
    dispatchValue?.call(ExpenseModel.fromJSON(data));
    statePage?.call(StateScreen.hasData);
  }
  
  @override
  Function(ExpenseModel p1)? dispatchValue;
  
  @override
  Future<void> update(String id, Map body) async {
    statePage?.call(StateScreen.waiting);
    final data = await dataSource.patch('${Endpoints.expense}/$id', body);
    dispatchValue?.call(ExpenseModel.fromJSON(data));
    statePage?.call(StateScreen.hasData);
  }
}