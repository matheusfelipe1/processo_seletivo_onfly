import 'package:processo_seletivo_onfly/core/repositories/providers/provider_repository.dart';
import 'package:processo_seletivo_onfly/core/repositories/providers/iprovider_repository.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

import '../../events/expense_events.dart';

abstract class IProividerController {
 
  void doAuthenticate();

  List<ExpenseModel> expenses = [];

  final IProviderRepository provider= ProviderRepository();

  dynamic onReceivedEvent(dynamic event, [ExpenseEvents? action]);

  Function(List<ExpenseModel>)? onDispatchExpenses;

  void onDisposeDetails();

  Function()? callDispose;
}