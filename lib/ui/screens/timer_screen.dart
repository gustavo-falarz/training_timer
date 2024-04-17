import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:training_timer/ui/screens/finished_screen.dart';

import '../../locale/localization.dart';
import '../../model/interval_model.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final List<IntervalModel> intervals;

  static const String path = '/timer';

  const TimerScreen({super.key, required this.intervals});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  var endBell = "sounds/end.ogg";
  var startBell = "sounds/start.ogg";
  var whistle = "sounds/whistle.ogg";
  CountDownController controller = CountDownController();
  int duration = 0;
  var index = -1;
  int round = 0;
  var intervalName = '';
  final assetsAudioPlayer = AssetsAudioPlayer();
  int formerTime = 0;

  void playBell() {
    AssetsAudioPlayer.playAndForget(
      Audio(startBell),
    );
  }

  void playWhistle() {
    AssetsAudioPlayer.playAndForget(
      Audio(whistle),
    );
  }

  void playEndBell() {
    AssetsAudioPlayer.playAndForget(
      Audio(endBell),
    );
  }

  String _getIntervalName() {
    if (index == -1) {
      return ref.read(appLocalizationsProvider).labelPrepare;
    }
    switch (widget.intervals[index].type) {
      case IntervalType.rest:
        return ref.read(appLocalizationsProvider).labelRest;
      case IntervalType.round:
        return ref.read(appLocalizationsProvider).labelRound;
      case IntervalType.delay:
        return ref.read(appLocalizationsProvider).labelPrepare;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(ref.read(appLocalizationsProvider).titleTimer),
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
              int durationIntSecs = duration.inSeconds;
              if (durationIntSecs != formerTime) {
                _playSound(durationIntSecs);
              }
              formerTime = durationIntSecs;

              return Function.apply(_defaultFormatterFunction, [duration]);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                onPressed: () {
                  if (controller.isPaused) {
                    controller.resume();
                  } else {
                    controller.start();
                  }
                },
                child: const Icon(Icons.play_arrow),
              ),
              FilledButton(
                onPressed: () {
                  if (!controller.isPaused) {
                    controller.pause();
                  }
                },
                child: const Icon(Icons.pause),
              ),
              FilledButton(
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
        intervalName = ref.watch(appLocalizationsProvider).labelDone;
        index = 0;
        context.pushReplacement(FinishedScreen.path);
      });
      controller.reset();
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

  void _playSound(int currentDuration) {
    if (index == -1) {
      return;
    }

    IntervalModel interval = widget.intervals[index];
    if (currentDuration == 0) {
      playBell();
    }
    if (interval.warning != 0 && interval.warning == currentDuration) {
      playWhistle();
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
    super.dispose();
  }

  String _getRounds() {
    List<IntervalModel> rounds = widget.intervals
        .where((element) => element.type == IntervalType.round)
        .toList();

    return rounds.length.toString();
  }
}
