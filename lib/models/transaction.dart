import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class LocalTransaction {
  Id? id;

  @Index(type: IndexType.value)
  late String title;

  late double amount;

  @Index()
  late DateTime date;

  late String category;

  late bool isIncome;
}
