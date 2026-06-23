import 'package:flutter/material.dart';
import 'services/db_service.dart';
import 'screens/setup_screen.dart';
import 'screens/lock_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/budget_settings_screen.dart';
import 'widgets/timeout_wrapper.dart';

void main() async {
  // Ensure Flutter engine bindings are ready before interacting with files
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user has an existing configuration setup
  final bool isFirstTime = await DbService.isFirstTimeSetup();

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrypted Expense Tracker',
      debugShowCheckedModeBanner: false,

      // Light Theme configuration
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),

      // --- DARK THEME CONFIGURATION ---
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      // Automatically follows your phone's system settings (Light/Dark)
      themeMode: ThemeMode.system,

      // --- FIXED HERE: Tell Flutter to start at the '/' route in the table ---
      initialRoute: '/',

      // --- REGISTER NAMED ROUTES ---
      routes: {
        // Dynamic root route handling first-time setup or lock screen
        '/': (context) => TimeoutWrapper(
          child: isFirstTime ? const SetupScreen() : const LockScreen(),
        ),
        '/dashboard': (context) => const DashboardScreen(),
        '/budget': (context) => const BudgetSettingsScreen(),
      },

      // --- GLOBAL PERMANENT FOOTER INJECTION ---
      builder: (context, child) {
        return Scaffold(
          body: child, // This renders the current active screen
          bottomNavigationBar: const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                '© 2026 • Made by Coder Pratap',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
