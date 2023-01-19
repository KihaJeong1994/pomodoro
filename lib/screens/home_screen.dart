import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int period = 0;
  int totalSeconds = 0;
  bool isRunning = false;
  int totalPomodoros = 0;
  late Timer timer;
  int minute = 0;
  int second = 0;

  Future<void> onTick(Timer timer) async {
    if (totalSeconds == 0) {
      timer.cancel();
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          pattern: [
            500,
            1000,
            500,
            1000,
            500,
            1000,
          ],
        );
      }
      setState(() {
        totalSeconds = period;
        second = totalSeconds % 60;
        minute = totalSeconds ~/ 60;
        isRunning = false;
        totalPomodoros++;
      });
    } else {
      setState(() {
        totalSeconds--;
        second = totalSeconds % 60;
        minute = totalSeconds ~/ 60;
      });
    }
  }

  void onStartPressed() {
    setState(() {
      isRunning = true;
      period = totalSeconds;
    });
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick, // onTick() means call this function immediately => so if you use onTick, Timer will call onTick(timer) for you automatically
    );
  }

  void onPausePressed() {
    setState(() {
      isRunning = false;
    });
    timer.cancel();
  }

  void onResetPressed() {
    setState(() {
      totalSeconds = period;
      minute = 0;
      second = 0;
    });
  }

  void onPomodoroResetPressed() {
    setState(() {
      totalPomodoros = 0;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: isRunning
                  ? Transform.translate(
                      offset: Offset(0, -30),
                      child: Text(
                        format(totalSeconds),
                        style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NumberPicker(
                          value: minute,
                          minValue: 0,
                          maxValue: 100,
                          onChanged: (value) => setState(() {
                            minute = value;
                            totalSeconds = 60 * minute + second;
                          }),
                          textStyle: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedTextStyle: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                          ),
                          textMapper: (numberText) => numberText.length <= 1
                              ? '0$numberText'
                              : numberText,
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        NumberPicker(
                          value: second,
                          minValue: 0,
                          maxValue: 59,
                          onChanged: (value) => setState(() {
                            second = value;
                            totalSeconds = 60 * minute + second;
                          }),
                          textStyle: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedTextStyle: TextStyle(
                            color: Theme.of(context).cardColor,
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                          ),
                          textMapper: (numberText) => numberText.length <= 1
                              ? '0$numberText'
                              : numberText,
                        ),
                      ],
                    ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      iconSize: 120,
                      color: Theme.of(context).cardColor,
                      onPressed: isRunning ? onPausePressed : onStartPressed,
                      icon: isRunning
                          ? const Icon(Icons.pause_circle_outline)
                          : const Icon(Icons.play_circle_outline)),
                  IconButton(
                    onPressed: onResetPressed,
                    icon: const Icon(Icons.restore_rounded),
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontSize: 60,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: onPomodoroResetPressed,
                          icon: const Icon(Icons.restore_rounded),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
