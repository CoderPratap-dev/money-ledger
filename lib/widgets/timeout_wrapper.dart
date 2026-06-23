import 'dart:async';
import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../screens/lock_screen.dart';

class TimeoutWrapper extends StatefulWidget {
  final Widget child;
  const TimeoutWrapper({super.key, required this.child});

  @override
  State<TimeoutWrapper> createState() => _TimeoutWrapperState();
}

class _TimeoutWrapperState extends State<TimeoutWrapper> {
  Timer? _timer;

  // Set inactivity limit (e.g., 2 minutes)
  static const _timeoutDuration = Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(_timeoutDuration, _handleTimeout);
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _startTimer();
    }
  }

  void _handleTimeout() async {
    // Lock the secure database instance down instantly
    await DbService.lockDatabase();

    if (mounted) {
      // Force user back to the Lock/PIN Screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LockScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listener looks for any pointer taps, movements, or gestures to reset the countdown
    return Listener(
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      child: widget.child,
    );
  }
}
