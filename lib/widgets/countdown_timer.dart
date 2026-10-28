import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onFinished;

  const CountdownTimer({
    super.key,
    required this.duration,
    this.onFinished,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _remaining = Duration.zero);
        widget.onFinished?.call();
      } else {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays.toString().padLeft(2, '0');
    final hours = (_remaining.inHours % 24).toString().padLeft(2, '0');
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    final hasDays = _remaining.inDays > 0;

    return Row(
      children: [
        if (hasDays) ...[
          _buildTimeBlock(context, value: days, label: 'Dias'),
          const SizedBox(width: 8),
        ],
        _buildTimeBlock(context, value: hours, label: 'Horas'),
        const SizedBox(width: 8),
        _buildTimeBlock(context, value: minutes, label: 'Min'),
        const SizedBox(width: 8),
        _buildTimeBlock(context, value: seconds, label: 'Seg'),
      ],
    );
  }

   Widget _buildTimeBlock(BuildContext context, {required String value, required String label}) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(4),
          border: Border(
            top: BorderSide(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.cinzelDecorative(
                color: theme.colorScheme.tertiary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }   
}