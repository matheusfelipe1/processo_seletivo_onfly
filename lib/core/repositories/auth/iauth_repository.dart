import 'package:processo_seletivo_onfly/core/middleware/datasource.dart';
import 'package:processo_seletivo_onfly/core/provider/databases/local_storage.dart';

abstract class IAuthRepository {
  final dataSource = DataSource();
  final localStorage = LocalStorage();
  Function(dynamic)? notifyExecutedAction;
  Future<void> doAuthenticate();
}