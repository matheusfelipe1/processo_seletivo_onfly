import 'package:processo_seletivo_onfly/core/provider/auth/auth_controller.dart';
import 'package:processo_seletivo_onfly/core/repositories/details/details_repository.dart';
import 'package:processo_seletivo_onfly/shared/enum/states_enum.dart';

import '../expense/expense_model.dart';

class DetailsModel {
  final _repository = DetailsRepository();
  final auth = AuthController();

  ExpenseModel? current;

  DetailsModel({this.current}) {
    _repository.dispatchValue = (p0) => {current = p0.$1, onReceivedDatas?.call(p0.$1), auth.onReceivedEvent(p0.$1, p0.$2)};
    _repository.statePage = (p0) => onStateScreenSwitched?.call(p0);
  }

  Function(StateScreen)? onStateScreenSwitched;

  Function(ExpenseModel)? onReceivedDatas;

  register() async {
    await _repository.register(current!.toJSON);
  }

  get(String id) async {
    await _repository.getUniqueData(id);
  }

  update(String id) async {
    await _repository.update(id, current!.toJSON);
  }
}