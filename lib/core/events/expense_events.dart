abstract class ExpenseEvents {}

class ExpenseDelete extends ExpenseEvents {}
class ExpenseDeleteFromDatabase extends ExpenseEvents {}
class ExpenseUpdate extends ExpenseEvents {}
class ExpenseAdded extends ExpenseEvents {}
class ExpenseAddedFromDatabase extends ExpenseEvents {}
class ExpenseUniqueData extends ExpenseEvents {}
class ExpenseAllData extends ExpenseEvents {}
class ExpenseErrorOnGet extends ExpenseEvents {}