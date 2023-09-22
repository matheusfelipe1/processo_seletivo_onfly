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
