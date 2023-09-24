import '../../../models/expense/expense_model.dart';
import '../../../shared/enum/states_enum.dart';
import '../../events/expense_events.dart';
import '../../middleware/datasource.dart';
import '../../provider/databases/local_storage.dart';

abstract class IHomeRepository {
  final dataSource = DataSource();
  final localStorage = LocalStorage();
  Function(List<ExpenseModel>)? notifyExecutedAction;
  Future<void> getAll([bool force = false]);
  Future<void> delete(String id);
  Function(ExpenseEvents, [String? id])? notifyEvents;
  Function(StateScreen newState)? stateScreen;
}