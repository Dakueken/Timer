import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Timer? _timer;
  int elapsedMilliseconds = 0;
  bool isRunning = false;

  String _formatTime(int totalMilliseconds) {
    final hours = totalMilliseconds ~/ 3600000;
    final minutes = (totalMilliseconds % 3600000) ~/ 60000;
    final seconds = (totalMilliseconds % 60000) ~/ 1000;
    final hundredths = ((totalMilliseconds % 1000) ~/ 10);

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');
    final hundredthsStr = hundredths.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr.$hundredthsStr";
  }

  void startStopwatch() {
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        elapsedMilliseconds += 10;
      });
    });
  }

  void stopStopwatch() {
    if (!isRunning) return;

    _timer?.cancel();
    setState(() {
      isRunning = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Stoppuhr gestoppt")));
  }

  void resetStopwatch() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      elapsedMilliseconds = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stopwatch")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Elapsed Time:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              _formatTime(elapsedMilliseconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : startStopwatch,
                  child: const Text("Start"),
                ),
                ElevatedButton(
                  onPressed: isRunning ? stopStopwatch : null,
                  child: const Text("Stop"),
                ),
                ElevatedButton(
                  onPressed: resetStopwatch,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
