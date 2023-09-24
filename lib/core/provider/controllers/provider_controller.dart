import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/events/navigation_event.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/iprovider_controller.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';
import 'package:processo_seletivo_onfly/shared/utils/internet_info.dart';

import '../../../models/expense/expense_model.dart';
import '../../../shared/routes/app_paths.dart';
import '../../events/expense_events.dart';

class ProividerController extends IProividerController {
  static final ProividerController _instance = ProividerController._();
  late Stream stream;
  ProividerController._() {
    doAuthenticate();
    startStream();
    verifyHasInternetConnection();
  }
  factory ProividerController() => _instance;

  @override
  void doAuthenticate() async {
    await provider.doAuthenticate();
    provider.notifyExecutedAction = onReceivedEvent;
  }

  @override
  onReceivedEvent(dynamic event, [ExpenseEvents? action]) {
    switch (event.runtimeType) {
      case const (List<ExpenseModel>):
        expenses = event;
        onDispatchExpenses?.call(expenses);
        break;
      case NavigationToHome:
        Get.toNamed(AppPaths.home);
        break;
      case ExpenseModel when ExpenseDelete == action.runtimeType:
        expenses.removeWhere((element) => element.id == event.id);
        onDispatchExpenses?.call(expenses);
        break;
      case ExpenseModel when ExpenseAdded == action.runtimeType:
        expenses.addWhere(event);
        onDispatchExpenses?.call(expenses);
        break;
      case ExpenseModel when ExpenseUpdate == action.runtimeType:
        expenses.addWhere(event);
        onDispatchExpenses?.call(expenses);
        break;
      default:
        break;
    }
  }

  @override
  void onDisposeDetails() {
    callDispose?.call();
  }

  @override
  void startStream() {
    stream = Stream.periodic(const Duration(milliseconds: 10000), (val) => val);
  }

  @override
  void verifyHasInternetConnection() {
    stream.listen((event) async {
      await Dio().head(VariablesStatic.connection).then((value) {
        InternetInfo.showHasIntent;
      }).catchError((onError) {
        InternetInfo.showNoInternet;
      });
    });
  }
}
