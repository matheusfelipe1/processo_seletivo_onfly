import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:processo_seletivo_onfly/models/details/details_model.dart';
import 'package:processo_seletivo_onfly/shared/animations/animation_loading.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';

import '../models/expense/expense_model.dart';
import '../shared/enum/states_enum.dart';
import '../shared/utils/inform_no_internet.dart';

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

  Function()? updateContext;

  DetailsViewModel(this.id);

  Rx<StateScreen> stateScreen = StateScreen.noHasData.obs;

  RxBool validForm = false.obs;

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
    verifyHasInternt();
    _model.onStateScreenSwitched = _onNotifyState;
    _model.onReceivedDatas = _onReceivedDatas;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
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
    id = data.id;
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
    updateContext?.call();
  }

  void registerOrEdit() {
    _model.current!.expenseDate = DateTime.parse(
            '${formatDateToRegister.format(date.text.toDateTime)}${time.text}:00')
        .toIso8601String();
    final textAmount = amount.text.replaceAll('\$ ', '').replaceAll(',', '');
    _model.current!.amount = double.tryParse(textAmount);
    _model.current!.description = description.text;
    if (id == null) {
      _model.register();
    } else {
      _model.update(id!);
    }
  }

  validValues() {
    if (description.text.isNotEmpty &&
        amount.text.isNotEmpty &&
        time.text.isNotEmpty &&
        date.text.isNotEmpty) {
      validForm.value = true;
    } else {
      validForm.value = false;
    }
  }

  void verifyHasInternt() async {
    await Dio().head(VariablesStatic.connection).catchError((onError) {
      InformNoIntenet.show();
    });
  }
}
