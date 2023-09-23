import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/models/details/details_model.dart';
import 'package:processo_seletivo_onfly/shared/animations/animation_loading.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';

import '../models/expense/expense_model.dart';
import '../shared/enum/states_enum.dart';

class DetailsViewModel extends GetxController {
  final _model = DetailsModel();

  final description = TextEditingController();
  final amount = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();

  final formatDate = DateFormat('yyyy/MM/dd');
  final formatDateToRegister = DateFormat("yyyy-MM-dd'T'");
  final formatTime = DateFormat('HH:mm');
  final formatCurrency =
      NumberFormat.currency(locale: 'en_US', decimalDigits: 2, symbol: '\$ ');

  String? id;

  DetailsViewModel(this.id);

  Rx<StateScreen> stateScreen = StateScreen.noHasData.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _getUniqueData(id);
    stateScreen.listenAndPump((event) {
      switch (event) {
        case StateScreen.waiting:
          Loading.show();
          break;
        case StateScreen.hasData:
          Loading.hide();
          break;
        default:
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _model.onStateScreenSwitched = _onNotifyState;
    _model.onReceivedDatas = _onReceivedDatas;
  }

  void _getUniqueData(String? id) {
    if (id != null) {
      _model.get(id);
    } else {
      _model.current = ExpenseModel();
    }
  }

  void _onNotifyState(StateScreen state) {
    stateScreen.value = state;
  }

  void _onReceivedDatas(ExpenseModel data) {
    description.text = data.description ?? '';
    amount.text = data.amount?.toString() ?? '';
    date.text = data.expenseDate ?? '';
    time.text = data.expenseDate ?? '';
    if (DateTime.tryParse(date.text) != null) {
      date.text = formatDate.format(DateTime.parse(date.text));
    }

    if (DateTime.tryParse(time.text) != null) {
      time.text = formatTime.format(DateTime.parse(time.text));
    }

    if (double.tryParse(amount.text) != null) {
      amount.text = formatCurrency.format(double.parse(amount.text));
    }
  }

  void registerOrEdit() {
    _model.current!.expenseDate =
        '${formatDateToRegister.format(date.text.toDateTime)}${time.text}:00';
        final textAmount = amount.text.replaceAll('\$ ', '');
    _model.current!.amount = double.tryParse(textAmount);
    _model.current!.description = description.text;
    if (id == null) {
      _model.register();
    } else {
      _model.update(id!);
    }
  }
}
