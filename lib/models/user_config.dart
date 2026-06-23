import 'package:isar/isar.dart';

part 'user_config.g.dart';

@collection
class UserConfig {
  Id? id;

  late String hashedPin;

  late bool isSetupComplete;

  double? globalMonthlyBudget; // Total monthly limit (e.g., 500.00)
  List<String>? categoryLimitKeys; // e.g., ['Food', 'Entertainment']
  List<double>? categoryLimitValues;
}
