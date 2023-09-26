# OnFly

## This is my selection process for OnFly.

## Important

- This application was built in Flutter 3.10.0.
>
    Flutter 3.10.0 • channel stable • https://github.com/flutter/flutter.git
    Framework • revision 84a1e904f4 (5 months ago) • 2023-05-09 07:41:44 -0700
    Engine • revision d44b5a94c9
    Tools • Dart 3.0.0 • DevTools 2.23.1
>
- APK link [here](https://drive.google.com/file/d/1xMgd64vtm_QpW-gYbyfCyZBJsPSbXksZ/view?usp=sharing)
- Was used MVVM (Model-View-ViewModel) architecture with Repository.
- A state management plugin was used, this plugin is used to perform view updates without the need to call setState with each view interaction.
- Was used a plugin called **sqflite** that is famous SQLite but for Flutter applications, this plugin is used to perform save data on internal database.
- A plugin called DIO was used, this plugin is used to structure our architecture and services standard.
- The folder called **viewmodels** is where localized our viewModels of MVVM (Model-View-ViewModel) architecture.
- The folder called **views** is where localized our views of MVVM (Model-View-ViewModel) architecture.
- The folder called **models** is where localized our model of MVVM (Model-View-ViewModel) architecture.
- The folder called **core** is where localized our business rules, there was our internal database, values objects (rich entities), contracts, events class, etc.
- The folder called **shared** is where our components are located and any location in the application can access the resources shared there, examples: Endpoints class, Utils class, File for extensions, Animations class, etc.
- In my applications. I have a habit of using abstract classes in any class that I consider to be of greater importance.

- **Details**:
- The folder widgets is folder that contains our custom widgets
- The folder extensions is folder that contains our extensions created.
- The folder routes is folder that contains our routes in the app.
- The folder static is folder that contains our static class.
- The folder utils is folder that contains our feedbacks actions.
- The contracts folder is the folder that contains our abstract classes from the repositories
- The implementations folder is the folder that contains our classes that extends abstract classes from repositories.
- The middleware folder is the folder that contains our DIO setup for services, is there that we do interceptors.
- The events folder is the folder that contains our events mapped in the app, for any action that MVVM dispatch and execute some business rule.
- The database folder is where our internal storage management will be located.
- The provider folder is where our data processing will be located, there will be communication between all parts of the application including our business rule ("frontend" business rule), of course, there is where we will send any type of data and it He will be responsible for knowing what he has to do with this data in addition to designating the app's flow.
- I created a cached folder so that we can manipulate data that we already fetch from the API, and thus avoid making requests all the time in the backend, although in this application there is not as much need for cached, but if it were a more robust application or one that requires large amounts of data processing, data, the use of cached manager is essential
- With that, our architecture looked like this:
>
    - lib/
        - core/
            - events/
            - middleware/
            - provider/
                - cached/
                - controllers/
                - databases/
            - repositories/
        - models/
            <models-of-applications>
        - shared/
            - animations/
            - enums/
            - extensions/
            - routes/
            - static/
            - utils/
            - widgets/
        - viewmodels/
            <viewModels-of-application>
        - views/
            <views-of-application>
            
>
## About code

> Action and Reaction
- Applying one of Solyd's basic concepts, which is the Principle of Responsibility, in the classes I create I always separate a method that receives an action and a method that triggers a reaction. Therefore, although the code sometimes seems more verbose, this type of approach makes it more manageable, achieving better scalability and readability.
- So most of my classes (Especially the abstract ones) have the methods:
>
      final IProviderRepository provider= ProviderRepository();

      dynamic onReceivedEvent(dynamic event, [ExpenseEvents? action]);
    
      Function(List<ExpenseModel>)? onDispatchExpenses;
>
- Where we have onReceivedEvent that receives events or data and handles them
- and onDispatchExpenses, which triggers events.
- In practice it looks like this:
>
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
>

> Abstractions
- I like to use abstract classes whenever I can or should, and this project was no different. I always use methods in abstractions to make certain automatic requests, in addition to applying the contract between them.
- In most methods you will see:
>
    abstract class IProividerController  {
    
      IProividerController() {
        onInit();
      }
     
      void doAuthenticate();
    
      void onInit();

    class ProividerController extends IProividerController {
    
      @override
      void onInit() {
        doAuthenticate();
        startStream();
        verifyHasInternetConnection();
        getALlInternalDatabase();
        InternetInfo.syncronizeDatas = executeDataProcessingFromAlert;
      }

>
- This makes the code more automated

> Events
- Events are another way to make the code more automated in addition to improving the scalability of the project as a whole, since I create events like this:
>
    abstract class DatabaseEvent {}
    class DatabaseAdded extends DatabaseEvent {}
    class DatabaseAddedAll extends DatabaseEvent {}
    class DatabaseRemoved extends DatabaseEvent {}
    class DatabaseRemovedDatabase extends DatabaseEvent {}
    class DatabaseRemovedAll extends DatabaseEvent {}
    class DatabaseUpdate extends DatabaseEvent {}
    class DatabaseUpdateSync extends DatabaseEvent {}
    class DatabaseGetAll extends DatabaseEvent {}
>
- Once I create the receiver this way:
>
    Future<dynamic> executeActions<T>(DatabaseEvent event,
      [dynamic query, StatusRequest? statusRequest]) async {
        switch (event.runtimeType) {
          case DatabaseAdded when query.runtimeType == ExpenseModel:
            final Map<String, Object?> data = {
              'idExpense': null,
              'description': query!.description,
              'expense_date': query.expenseDate,
              'amount': query.amount,
              'typeEvent': 'DatabaseAdded',
              'notSynchronized': query.notSynchronized == true ? 1 : 0
            };
            await insertData(data);
            break;
>
- I just need to fire the event for this class and then it will decide what to do with the data received, in this case it will decide whether to insert, update, remove or fetch the data from the internal database.
> Cache
- With this custom cached we place the expense list arrays in a static location, when searching the API first it will try to search the set, if there is data it will return from there.
>
    import 'package:processo_seletivo_onfly/models/expense/expense_model.dart';

    class CustomCachedManager {
      static Set<Map> datas = {};
    
      static Set get<T>(String key) {
        return datas.where((element) => element['key'] == key).toSet();
      }
    
      static void post(String key, List<ExpenseModel> list) {
        datas.add({'key': key, 'data': list});
      }
    
      static void put(String key, List<ExpenseModel> list) {
        datas.removeWhere((element) => element['key'] == key);
        datas.add({'key': key, 'data': list});
      }
    }
>
- We also count on the presence of Set, Set is nothing more than a set of elements that have duplicates, that is, if there is already a value within this static variable with this key, you can even try to add it but it will have no effect

> Memory
- It's that thing, it's not enough for an application to have good aesthetics, to have a good objective but without having good operation/performance, one of the best ways to avoid poor performance is to check the current state of your device's memory in correlation with your application, In this application, although it has a non-complex purpose, I found it interesting to observe its state so that we could obtain the best possible performance, so I did:
>
    import 'package:flutter/material.dart';

    class DetectMemoryLeaks extends WidgetsBindingObserver {
      @override
      void didHaveMemoryPressure() {
        debugPrint('We had a memory leak');
        super.didHaveMemoryPressure();
      }
      @override
      void didChangeAppLifecycleState(AppLifecycleState state) {
        // TODO: implement didChangeAppLifecycleState
        super.didChangeAppLifecycleState(state);
        debugPrint(state.toString());
      }
    }
    
    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ]);
      final memory = DetectMemoryLeaks();
      WidgetsBinding.instance.addObserver(memory);
      await dotenv.load(fileName: '.env');
      runApp(const AppWidget());
    }

>
## Conclusion
In advance, I would like to thank the company OnFly for the opportunity for this experience and I hope you enjoy it.
