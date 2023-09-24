import 'package:processo_seletivo_onfly/core/events/expense_events.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

import '../../../shared/enum/states_enum.dart';

abstract class IDetailsRepository {

  final dataSource = DataSource();

  Function(StateScreen)? statePage;

  Function((ExpenseModel, ExpenseEvents))? dispatchValue;

  Future<void> getUniqueData(String id);

  Future<void> register(Map body);

  Future<void> update(String id, Map body);
}