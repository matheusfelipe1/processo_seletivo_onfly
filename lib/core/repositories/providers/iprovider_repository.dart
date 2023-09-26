import 'package:processo_seletivo_onfly/core/events/expense_events.dart';
import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';
import 'package:processo_seletivo_onfly/core/provider/databases/local_storage.dart';

import '../../../models/expense/expense_model.dart';
import '../../../shared/enum/status_request.dart';
import '../../events/database_events.dart';

abstract class IProviderRepository {
  final dataSource = DataSource();
  final localStorage = LocalStorage();
  Function(dynamic, [ExpenseEvents? event])? notifyExecutedAction;
  Future<void> doAuthenticate();
  Future<void> getAll();
  Future<List<(ExpenseModel, StatusRequest, DatabaseEvent)>> synchronize(List<(ExpenseModel, DatabaseEvent)> datas);

  Future<StatusRequest> register(Map body);

  Future<StatusRequest> update(String id, Map body);

  Future<StatusRequest> delete(String id);
}