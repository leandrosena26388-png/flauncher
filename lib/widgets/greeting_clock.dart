import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GreetingClock extends StatefulWidget {
  const GreetingClock({super.key});

  @override
  State<GreetingClock> createState() => _GreetingClockState();
}

class _GreetingClockState extends State<GreetingClock> {
  late DateTime _now;
  late Timer _timer;
  late DateFormat _timeFormat;
  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timeFormat = DateFormat('H:mm', Platform.localeName);
    _dateFormat = DateFormat('EEEE d MMMM', Platform.localeName);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _greeting {
    final h = _now.hour;
    if (h < 12) return 'BOM DIA';
    if (h < 18) return 'BOA TARDE';
    return 'BOA NOITE';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _greeting,
          style: const TextStyle(
              fontSize: 14, letterSpacing: 3, color: Colors.white54),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _timeFormat.format(_now),
              style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  height: 1),
            ),
            const SizedBox(width: 16),
            Container(width: 1, height: 36, color: Colors.white24),
            const SizedBox(width: 16),
            Text(
              _dateFormat.format(_now).toUpperCase(),
              style: const TextStyle(
                  fontSize: 16, letterSpacing: 2, color: Colors.white60),
            ),
          ],
        ),
      ],
    );
  }
}
