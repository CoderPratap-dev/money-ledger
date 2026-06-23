import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart'; // --- NEW: Biometrics package ---
import '../services/db_service.dart';
import '../widgets/pin_pad.dart';
import 'dashboard_screen.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _inputPin = '';
  String _statusMessage = 'Enter PIN to unlock database';
  bool _hasError = false;

  // Instantiate the local auth engine plugin
  final LocalAuthentication _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    // Fire off the fingerprint check system dialog automatically on launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticateWithFingerprint();
    });
  }

  // --- NEW: Hardware Biometric Authentication Trigger ---
  Future<void> _authenticateWithFingerprint() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) return;

      // Bring up native system OS authentication dialog container
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to unlock your ledger',
        options: const AuthenticationOptions(
          biometricOnly:
              true, // Strictly bypasses general lockscreen PIN fallback loops
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        // Run the custom secure database bypass mechanism using internal configs
        final success = await DbService.initializeWithSavedPin();
        if (success && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Biometric authentication failed. Try PIN.';
      });
    }
  }

  void _handleKeyPress(String num) {
    if (_inputPin.length < 6) {
      setState(() {
        _inputPin += num;
        _hasError = false;
      });

      if (_inputPin.length >= 4) {
        _verifyAndUnlock();
      }
    }
  }

  void _handleDelete() {
    if (_inputPin.isNotEmpty) {
      setState(() {
        _inputPin = _inputPin.substring(0, _inputPin.length - 1);
      });
    }
  }

  void _verifyAndUnlock() async {
    final success = await DbService.initializeDatabase(_inputPin);

    if (success) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } else {
      if (_inputPin.length == 6) {
        setState(() {
          _inputPin = '';
          _statusMessage = 'Incorrect PIN! Access Denied.';
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- NEW: Added a fingerprint floating trigger button for manual rescans ---
      floatingActionButton: FloatingActionButton(
        onPressed: _authenticateWithFingerprint,
        tooltip: 'Scan Fingerprint',
        child: const Icon(Icons.fingerprint),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _hasError ? Icons.lock_open_outlined : Icons.lock_outline,
                size: 72,
                color: _hasError ? Colors.red : Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _hasError
                      ? Colors.red
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: const EdgeInsets.all(6),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < _inputPin.length
                          ? Theme.of(context).primaryColor
                          : Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              PinPad(
                onNumPressed: _handleKeyPress,
                onDeletePressed: _handleDelete,
                onClearPressed: () => setState(() => _inputPin = ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
