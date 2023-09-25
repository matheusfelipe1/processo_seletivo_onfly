class ExpenseModel {
  double? amount;
  String? collectionId;
  String? collectionName;
  String? created;
  String? description;
  String? expenseDate;
  String? id;
  String? latitude;
  String? longitude;
  String? updated;
  bool? notSynchronized;

  ExpenseModel(
      {this.amount,
      this.collectionId,
      this.collectionName,
      this.created,
      this.description,
      this.expenseDate,
      this.id,
      this.latitude,
      this.longitude,
      this.updated,
      this.notSynchronized});

  factory ExpenseModel.fromJSON(Map<String?, dynamic> json) => ExpenseModel(
              amount: json['amount'].toDouble(),
              collectionId: json['collectionId'],
              collectionName: json['collectionName'],
              created: json['created'],
              description: json['description'],
              expenseDate: json['expense_date'],
              id: json['id'],
              latitude: json['latitude'],
              longitude: json['longitude'],
              updated: json['updated'],
              notSynchronized: json['notSynchronized'],
            );

  Map get toJSON => {
        'amount': amount!.toDouble(),
        'description': description!,
        'expense_date': expenseDate!,
        'id': id,
      };
}
