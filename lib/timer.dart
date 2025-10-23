import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  final _timerTextController = TextEditingController();
  bool isRunning = false;
  int time = 0, seconds = 0, hours = 0, minutes = 0;
  bool _cancelled = false;

  Future<void> startTimer() async {
    final input = int.tryParse(_timerTextController.text);
    if (input == null || input <= 0) return;

    setState(() {
      time = input;
      isRunning = true;
      _cancelled = false;
    });

    while (time > 0 && !_cancelled) {
      await Future.delayed(const Duration(seconds: 1));
      if (!_cancelled && mounted) {
        setState(() {
          time--;
        });
      }
    }

    if (!_cancelled && mounted) {
      setState(() {
        isRunning = false;
      });
    }
  }

  Future<void> resumeTimer() async {
    if (time > 0 && !isRunning) {
      setState(() {
        isRunning = true;
        _cancelled = false;
      });

      while (time > 0 && !_cancelled) {
        await Future.delayed(const Duration(seconds: 1));
        if (!_cancelled && mounted) {
          setState(() {
            time--;
          });
        }
      }

      if (!_cancelled && mounted) {
        setState(() {
          isRunning = false;
        });
      }
    }
  }

  void stopTimer() {
    setState(() {
      _cancelled = true;
      isRunning = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Timer Stopped")));
  }

  @override
  void dispose() {
    _timerTextController.dispose();
    _cancelled = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _timerTextController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: "Enter Seconds"),
            ),
            Text(
              "Remaining Time: ${_formatTime(time)}",
              style: const TextStyle(fontSize: 24),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : startTimer,
                  child: const Text("Starten"),
                ),
                ElevatedButton(
                  onPressed: isRunning ? null : resumeTimer,
                  child: const Text("Resume"),
                ),
                ElevatedButton(
                  onPressed: isRunning ? stopTimer : null,
                  child: const Text("Stop"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
