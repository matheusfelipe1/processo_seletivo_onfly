import 'package:processo_seletivo_onfly/core/repositories/auth/auth_repository.dart';
import 'package:processo_seletivo_onfly/core/repositories/auth/iauth_repository.dart';
import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

abstract class IAuthController {
 
  void doAuthenticate();

  List<ExpenseModel> expenses = [];

  final IAuthRepository auth = AuthRepository();

}