
class VariablesStatic {
  static String get TOKEN => 'token';
  static String get expenseList => 'expenseList';
  static String get connection => 'https://www.google.com';
  static String get dbName => 'onflydb';
  static String get expensesTable =>
      'expense';
  static String get expenses =>
      'CREATE TABLE IF NOT EXISTS expense(id INTEGER PRIMARY KEY AUTOINCREMENT, idExpense TEXT, description TEXT, amount REAL, expense_date TEXT, typeEvent TEXT)';
}