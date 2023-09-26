import 'package:processo_seletivo_onfly/core/repositories/providers/provider_repository.dart';
import 'package:processo_seletivo_onfly/core/repositories/providers/iprovider_repository.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

import '../../../shared/enum/status_request.dart';
import '../../events/database_events.dart';
import '../../events/expense_events.dart';

abstract class IProividerController  {

  IProividerController() {
    onInit();
  }
 
  void doAuthenticate();

  void onInit();

  List<ExpenseModel> expenses = [];
  // List<ExpenseModel> expensesInternalDatabase = [];

  final IProviderRepository provider= ProviderRepository();

  dynamic onReceivedEvent(dynamic event, [ExpenseEvents? action]);

  Function(List<ExpenseModel>)? onDispatchExpenses;

  void onDisposeDetails();

  Function()? callDispose;

  void verifyHasInternetConnection();

  void startStream();

  void getALlInternalDatabase();

  void dataProcessing(List<(ExpenseModel, StatusRequest, DatabaseEvent)> datas);

  void executeDataProcessingFromAlert();

  void getListFromInternalDatabase();

  Future<List<ExpenseModel>> getExpenseListFromDatabase();
}