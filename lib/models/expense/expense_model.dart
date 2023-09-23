import '../../shared/enum/card_enum.dart';

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
  TypeCardEnum? typeCard;

  ExpenseModel({
    this.amount,
    this.collectionId,
    this.collectionName,
    this.created,
    this.description,
    this.expenseDate,
    this.id,
    this.latitude,
    this.longitude,
    this.updated,
    this.notSynchronized,
    this.typeCard
  });

  factory ExpenseModel.fromJSON(Map<String, dynamic> json) => ExpenseModel(
        amount: json['amount'],
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
        typeCard: json['typeCard'] ?? TypeCardEnum.task,
      );
}
