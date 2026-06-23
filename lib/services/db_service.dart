import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/transaction.dart';
import '../models/user_config.dart';

class DbService {
  static Isar? _isar;

  /// Opens the database safely with explicit manual PIN verification
  static Future<bool> initializeDatabase(String pin) async {
    if (_isar != null) return true;

    final dir = await getApplicationDocumentsDirectory();

    try {
      // 1. Open config_db temporarily to read the saved master hash
      final tempIsar = await Isar.open(
        [UserConfigSchema],
        directory: dir.path,
        name: 'config_db',
      );

      final config = await tempIsar.userConfigs.where().findFirst();
      await tempIsar.close();

      // 2. If configuration exists, validate the incoming PIN
      if (config != null) {
        final bytes = utf8.encode(pin);
        final incomingHash = sha256.convert(bytes).toString();

        // --- CRITICAL SECURITY CHECK ---
        if (incomingHash != config.hashedPin) {
          return false; // Deny access right here if hashes don't match!
        }
      }

      // 3. If validation succeeds, open the operational database instance
      _isar = await Isar.open(
        [LocalTransactionSchema, UserConfigSchema],
        directory: dir.path,
        name: 'secure_isar_db',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Opens the main transactional engine immediately after fingerprint verification matches successfully
  static Future<bool> initializeWithSavedPin() async {
    if (_isar != null) return true;

    final dir = await getApplicationDocumentsDirectory();

    try {
      final tempIsar = await Isar.open(
        [UserConfigSchema],
        directory: dir.path,
        name: 'config_db',
      );

      final config = await tempIsar.userConfigs.where().findFirst();
      await tempIsar.close();

      // Ensure a master setup footprint already exists
      if (config != null) {
        _isar = await Isar.open(
          [LocalTransactionSchema, UserConfigSchema],
          directory: dir.path,
          name: 'secure_isar_db',
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // --- Update Budget Settings Overwriting ID 1 ---
  static Future<void> updateBudget({
    double? global,
    List<String>? keys,
    List<double>? values,
  }) async {
    final dir = await getApplicationDocumentsDirectory();

    // Open config_db to read and persist budget configurations permanently
    final tempIsar = await Isar.open(
      [UserConfigSchema],
      directory: dir.path,
      name: 'config_db',
    );

    // Grab existing setup file to avoid clearing your hashed PIN
    final existingConfig = await tempIsar.userConfigs.where().findFirst();
    final config = existingConfig ?? UserConfig();

    // CRITICAL FIX: Explicitly bind to ID 1 so we update instead of duplicating rows
    config.id = 1;
    config.globalMonthlyBudget = global;
    if (keys != null) config.categoryLimitKeys = keys;
    if (values != null) config.categoryLimitValues = values;

    await tempIsar.writeTxn(() async {
      await tempIsar.userConfigs.put(config);
    });

    await tempIsar.close();
  }

  /// NEW HELPER: Safely fetches the user configuration from the config database
  static Future<UserConfig?> getUserConfig() async {
    final dir = await getApplicationDocumentsDirectory();
    try {
      final tempIsar = await Isar.open(
        [UserConfigSchema],
        directory: dir.path,
        name: 'config_db',
      );
      final config = await tempIsar.userConfigs.where().findFirst();
      await tempIsar.close();
      return config;
    } catch (e) {
      return null;
    }
  }

  // --- Calculate Total Expense Volume For Current Month ---
  static Future<double> getThisMonthsTotalSpending() async {
    if (_isar == null) return 0.0;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    // Pull transactions that fall into the active calendar month window
    final transactions = await _isar!.localTransactions
        .filter()
        .dateGreaterThan(startOfMonth, include: true)
        .dateLessThan(endOfMonth)
        .findAll();

    return transactions
        .where(
          (t) => !t.isIncome,
        ) // Filters everything flagged as an Expense cleanly
        .fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  static Future<void> lockDatabase() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }

  static Future<bool> isFirstTimeSetup() async {
    final dir = await getApplicationDocumentsDirectory();
    try {
      final tempIsar = await Isar.open(
        [UserConfigSchema],
        directory: dir.path,
        name: 'config_db',
      );
      final config = await tempIsar.userConfigs.where().findFirst();
      await tempIsar.close();
      return config == null;
    } catch (e) {
      return false;
    }
  }

  static Future<void> saveInitialSetup(String pin) async {
    final dir = await getApplicationDocumentsDirectory();
    final tempIsar = await Isar.open(
      [UserConfigSchema],
      directory: dir.path,
      name: 'config_db',
    );

    final bytes = utf8.encode(pin);
    final hashedPin = sha256.convert(bytes).toString();

    final config = UserConfig()
      ..id =
          1 // CRITICAL FIX: Ensure initialization starts explicitly at ID 1
      ..hashedPin = hashedPin
      ..isSetupComplete = true;

    await tempIsar.writeTxn(() async {
      await tempIsar.userConfigs.put(config);
    });

    await tempIsar.close();
  }

  /// Global access transaction engine wrapper
  static Future<void> writeTxn(Future<void> Function() callback) async {
    if (_isar == null) throw Exception("Database is locked!");
    await _isar!.writeTxn(callback);
  }

  static Isar get instance {
    if (_isar == null) throw Exception("Database is locked!");
    return _isar!;
  }
}
