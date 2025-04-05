import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:training_timer/fighter_picker.dart';
import 'package:training_timer/model/match_model.dart';
import 'package:training_timer/providers.dart';
import 'package:training_timer/ui/screens/finished_screen.dart';

import '../../locale/localization.dart';
import '../../model/interval_model.dart';
import '../shared_widgets/adaptive_layouts.dart';

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
  bool isPlaying = false;

  void playBell() {
    assetsAudioPlayer.open(
      Audio(startBell),
      audioFocusStrategy: const AudioFocusStrategy.request(
        resumeAfterInterruption: true,
        resumeOthersPlayersAfterDone: true,
      ),
    );

    // AssetsAudioPlayer.playAndForget(
    //   Audio(startBell),
    // );
  }

  void playWhistle() {
    assetsAudioPlayer.open(
      Audio(whistle),
      audioFocusStrategy: const AudioFocusStrategy.request(
        resumeAfterInterruption: true,
        resumeOthersPlayersAfterDone: true,
      ),
    );

    // AssetsAudioPlayer.playAndForget(
    //   Audio(whistle),
    // );
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
    List<MatchModel> matches = ref.watch(matchesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(ref.read(appLocalizationsProvider).titleTimer),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: AdaptiveFillContainer(
          child: Column(
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
              const Gap(10.0),
              CircularCountDownTimer(
                duration: duration,
                initialDuration: duration,
                controller: controller,
                width: MediaQuery.of(context).size.width / 1.7,
                height: 230.0,
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
              const Gap(50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                    style: (isPlaying)
                        ? ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).disabledColor),
                          )
                        : null,
                    onPressed: () {
                      if (!isPlaying) {
                        if (controller.isPaused.value) {
                          controller.resume();
                        } else {
                          controller.start();
                        }
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                  FilledButton(
                    style: (isPlaying)
                        ? null
                        : ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).disabledColor),
                          ),
                    onPressed: () {
                      setState(() {
                        if (!controller.isPaused.value) {
                          controller.pause();
                          isPlaying = false;
                        }
                      });
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
                  FilledButton(
                    onPressed: () {
                      pickMatches(ref);
                    },
                    child: const Icon(Icons.shuffle),
                  ),
                ],
              ),
              const Gap(20.0),
              Visibility(
                visible: ref.watch(fighterOutProvider) != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.waving_hand_rounded),
                    const Gap(5.0),
                    Text(
                      ref.watch(appLocalizationsProvider).fighterLefOut(
                          ref.watch(fighterOutProvider)?.name ?? ''),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20.0),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${matches[index].fighter1}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Image.asset(
                                'images/icons/vs.png',
                                height: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${matches[index].fighter2}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
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
