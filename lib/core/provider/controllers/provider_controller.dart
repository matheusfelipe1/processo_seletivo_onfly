import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:processo_seletivo_onfly/core/events/database_events.dart';
import 'package:processo_seletivo_onfly/core/events/navigation_event.dart';
import 'package:processo_seletivo_onfly/core/provider/cached/custom_cached.dart';
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
  ProividerController._();

  factory ProividerController() => _instance;

  final database = InternalDatabase.instance;

  @override
  void onInit() {
    doAuthenticate();
    startStream();
    verifyHasInternetConnection();
    getALlInternalDatabase();
    InternetInfo.syncronizeDatas = executeDataProcessingFromAlert;
  }

  @override
  void doAuthenticate() async {
    await provider.doAuthenticate();
    provider.notifyExecutedAction = onReceivedEvent;
  }

  @override
  onReceivedEvent(dynamic event, [ExpenseEvents? action]) async {
    switch (event.runtimeType) {
      case const (List<ExpenseModel>)
          when ExpenseErrorOnGet == action.runtimeType:
        expenses = await getExpenseListFromDatabase();
        onDispatchExpenses?.call(expenses);
        break;
      case const (List<ExpenseModel>) when action == null:
        expenses = event;
        database.executeActions(DatabaseAddedAll(), expenses);
        onDispatchExpenses?.call(expenses);
        if (expenses.isEmpty && event.isEmpty) {
          getListFromInternalDatabase();
        }
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
      case const (List<ExpenseModel>)
          when ExpenseAddedFromDatabase == action.runtimeType:
        expenses = event;
        expenses.sort((a, b) => b.expenseDate
            .toString()
            .toDate
            .compareTo(a.expenseDate.toString().toDate));
        onDispatchExpenses?.call(expenses);
        break;
      case ExpenseModel when ExpenseUpdate == action.runtimeType:
        expenses.addWhere(event);
        onDispatchExpenses?.call(expenses);
        break;
      default:
        break;
    }
    CustomCachedManager.put(VariablesStatic.expenseList, expenses);
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
        switch (datas.any((e) => e.$1.notSynchronized == true)) {
          case true:
            onReceivedEvent(datas, ExpenseAddedFromDatabase());
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
    await dataProcessing(datasSyncronized);
  }

  @override
  Future<void> dataProcessing(
      List<(ExpenseModel, StatusRequest, DatabaseEvent)> datas) async {
    expenses = [];
    for (var element in datas) {
      switch (element.$2) {
        case StatusRequest.failure:
          await database.executeActions(element.$3, element.$1);
          break;
        default:
          await database.executeActions(DatabaseUpdateSync(), element.$1);
          break;
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
      final datasSyncronized = await provider.synchronize(datas);
      await database.executeActions(DatabaseRemovedAll());
      await dataProcessing(datasSyncronized);
      await Future.delayed(const Duration(milliseconds: 700));
      await provider.getAll();
      Loading.hide();
    }).catchError((onError) {
      InformNoIntenet.showMessageInternalDatabase4();
    });
  }

  @override
  void getListFromInternalDatabase() async {
    // ignore: body_might_complete_normally_catch_error
    await Dio().head(VariablesStatic.connection).catchError((onError) async {
      final list = await database.executeActions(DatabaseGetAll()) as List;
      if (expenses.isEmpty && list.isNotEmpty) {
        final datas = list.map((e) => e.$1).toList().cast<ExpenseModel>();
        Future.delayed(const Duration(milliseconds: 100), () {
          expenses = datas;
          expenses.sort((a, b) => b.expenseDate
              .toString()
              .toDate
              .compareTo(a.expenseDate.toString().toDate));
          onDispatchExpenses?.call(expenses);
        });
      }
    });
  }

  @override
  Future<List<ExpenseModel>> getExpenseListFromDatabase() async {
    final datas = await database.executeActions(DatabaseGetAll())
        as List<(ExpenseModel, DatabaseEvent)>;
    return datas.map((e) => e.$1).toList()
      ..sort((a, b) => b.expenseDate
          .toString()
          .toDate
          .compareTo(a.expenseDate.toString().toDate));
    
  }
}
