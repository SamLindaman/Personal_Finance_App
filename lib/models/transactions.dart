enum ExpenseType { Food, Alcohol, Necessity, Fun, Other }

class Transactions {
  int id;
  String title;
  double amount;
  DateTime date;
  int expenseType;

  Transactions({this.id, this.title, this.amount, this.date, this.expenseType});
}
