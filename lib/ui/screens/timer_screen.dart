import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/interval_model.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final List<IntervalModel> intervals;

  static const String path = '/timer';

  const TimerScreen({super.key, required this.intervals});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  final audioPlayer = AudioPlayer();
  var endBell = "sounds/end.ogg";
  var startBell = "sounds/start.ogg";
  var whistle = "sounds/whistle.ogg";
  CountDownController controller = CountDownController();
  int duration = 0;
  var index = -1;
  int round = 0;
  var intervalName = '';

  Future<void> playStartBell() async {
    Future.microtask(() {
      audioPlayer.play(AssetSource(startBell));
    });
    // await audioPlayer.play(AssetSource(startBell));
  }

  Future<void> playWhistle() async {
    Future.microtask(() {
      audioPlayer.play(AssetSource(whistle));
    });
    // await audioPlayer.play(AssetSource(whistle));
  }

  Future<void> playEndBell() async {
    Future.microtask(() {
      audioPlayer.play(AssetSource(endBell));
    });
    // await audioPlayer.play(AssetSource(endBell));
  }

  String _getIntervalName() {
    if (index == -1) {
      return 'Prepare';
    }
    switch (widget.intervals[index].type) {
      case IntervalType.rest:
        return 'Rest';
      case IntervalType.round:
        return 'Round';
      case IntervalType.delay:
        return 'Prepare';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round timer'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Text(
            '$round / ${_getRounds()}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            intervalName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircularCountDownTimer(
            duration: duration,
            initialDuration: duration,
            controller: controller,
            width: MediaQuery.of(context).size.width / 1.7,
            height: 350.0,
            ringColor: Theme.of(context).colorScheme.secondary,
            ringGradient: null,
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            fillGradient: null,
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundGradient: null,
            strokeWidth: 20.0,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: false,
            onComplete: () {
              _updateRound();
              _updateIntervalName();
              duration = widget.intervals[index].duration;
              controller.restart(duration: duration);
            },
            onChange: (String timeStamp) {
              debugPrint('Countdown Changed $timeStamp');
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              _playSound(duration);
              return Function.apply(_defaultFormatterFunction, [duration]);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (controller.isPaused) {
                    controller.resume();
                  } else {
                    controller.start();
                  }
                },
                child: const Icon(Icons.play_arrow),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!controller.isPaused) {
                    controller.pause();
                  }
                },
                child: const Icon(Icons.pause),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.reset();
                  Navigator.pop(context);
                },
                child: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateRound() {
    index++;
    if (index == -1) {
      return;
    } else if (index == widget.intervals.length) {
      setState(() {
        intervalName = 'Done';
        index = 0;
        controller.pause();
      });
    } else if (widget.intervals[index].type == IntervalType.round) {
      setState(() {
        round++;
      });
    }
  }

  void _updateIntervalName() {
    setState(() {
      intervalName = _getIntervalName();
    });
  }

  void _playSound(Duration currentDuration) {
    if (index == -1) {
      return;
    }

    IntervalModel interval = widget.intervals[index];
    if (interval.type != IntervalType.delay) {
      if (currentDuration.inSeconds == interval.duration) {
        playStartBell();
      }
      if (currentDuration.inSeconds == 0) {
        playStartBell();
      }
      if (interval.warning != 0 &&
          interval.warning == currentDuration.inSeconds) {
        playWhistle();
      }
    }
  }

  String _defaultFormatterFunction(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    final twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  String _getRounds() {
    List<IntervalModel> rounds = widget.intervals
        .where((element) => element.type == IntervalType.round)
        .toList();

    return rounds.length.toString();
  }
}
