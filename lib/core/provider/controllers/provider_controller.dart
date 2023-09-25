import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/events/database_events.dart';
import 'package:processo_seletivo_onfly/core/events/navigation_event.dart';
import 'package:processo_seletivo_onfly/core/provider/controllers/iprovider_controller.dart';
import 'package:processo_seletivo_onfly/shared/animations/animation_loading.dart';
import 'package:processo_seletivo_onfly/shared/enum/status_request.dart';
import 'package:processo_seletivo_onfly/shared/extensions/app_extensions.dart';
import 'package:processo_seletivo_onfly/shared/static/variables_static.dart';
import 'package:processo_seletivo_onfly/shared/utils/inform_no_internet.dart';
import 'package:processo_seletivo_onfly/shared/utils/internet_info.dart';

import '../../../models/expense/expense_model.dart';
import '../../../shared/routes/app_paths.dart';
import '../../events/expense_events.dart';
import '../databases/internal_database.dart';

class ProividerController extends IProividerController {
  static final ProividerController _instance = ProividerController._();
  late Stream stream;
  ProividerController._() {
    doAuthenticate();
    startStream();
    verifyHasInternetConnection();
    getALlInternalDatabase();
    InternetInfo.syncronizeDatas = executeDataProcessingFromAlert;
  }
  factory ProividerController() => _instance;

  final database = InternalDatabase.instance;

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
        if (expensesInternalDatabase.isNotEmpty) {
          for (var element in expensesInternalDatabase) {
            expenses.addWhereFromDatabase(element);
          }
        }
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
      case ExpenseModel when ExpenseAddedFromDatabase == action.runtimeType:
        expenses.addWhereFromDatabase(event);
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
      await Dio().head(VariablesStatic.connection).then((value) async {
        final datas = await database.executeActions(DatabaseGetAll())
            as List<(ExpenseModel, DatabaseEvent)>;
        expensesInternalDatabase = datas.map((e) => e.$1).toList();
        switch (datas.isNotEmpty) {
          case true:
            for (var item in datas) {
              onReceivedEvent(item.$1, ExpenseAddedFromDatabase());
            }
            InternetInfo.showHasIntent;
            break;
          default:
            InternetInfo.removeSnackbar;
        }
      }).catchError((onError) {
        InternetInfo.showNoInternet;
      });
    });
  }

  @override
  void getALlInternalDatabase() async {
    await database.initialize();
    final datas = await database.executeActions(DatabaseGetAll())
        as List<(ExpenseModel, DatabaseEvent)>;
    final datasSyncronized = await provider.synchronize(datas);
    dataProcessing(datasSyncronized);
  }

  @override
  void dataProcessing(
      List<(ExpenseModel, StatusRequest, DatabaseEvent)> datas) async {
    await database.executeActions(DatabaseRemovedAll());
    expensesInternalDatabase = [];
    expenses = [];
    expensesInternalDatabase = datas.map((e) => e.$1).toList();
    for (var element in datas) {
      switch (element.$2) {
        case StatusRequest.failure:
          await database.executeActions(element.$3, element.$1);
          break;
        default:
      }
    }
  }

  @override
  void executeDataProcessingFromAlert() async {
    await Dio().head(VariablesStatic.connection).then((value) async {
      Loading.show();
      InternetInfo.removeSnackbar;
      final datas = await database.executeActions(DatabaseGetAll())
          as List<(ExpenseModel, DatabaseEvent)>;
      expensesInternalDatabase = datas.map((e) => e.$1).toList();
      final datasSyncronized = await provider.synchronize(datas);
      dataProcessing(datasSyncronized);
      await Future.delayed(const Duration(milliseconds: 700));
      await provider.getAll();
      Loading.hide();
    }).catchError((onError) {
      InformNoIntenet.showMessageInternalDatabase4();
    });
  }
}
