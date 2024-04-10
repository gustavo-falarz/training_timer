import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:training_timer/locale/localization.dart';
import 'package:training_timer/ui/screens/timer_screen.dart';

import '../../model/interval_model.dart';
import '../../model/timer_data.dart';
import '../shared_widgets/double_field.dart';
import '../shared_widgets/single_field.dart';


class SetupTimerScreen extends ConsumerStatefulWidget {
  const SetupTimerScreen({super.key});

  static const String path = '/';


  @override
  ConsumerState<SetupTimerScreen> createState() => _SetupTimerScreenState();
}

class _SetupTimerScreenState extends ConsumerState<SetupTimerScreen> {

  int rounds = 6;
  int roundMin = 3;
  int roundSec = 0;
  int restMin = 1;
  int restSec = 0;
  int delay = 10;
  int restWarning = 10;
  int roundWarning = 10;

  String title = '';

  int calcRound() {
    return roundMin * 60 + roundSec;
  }

  int calcRest() {
    return restMin * 60 + restSec;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.read(appLocalizationsProvider).appName),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleField(
              initialValue: rounds,
              label: ref.read(appLocalizationsProvider).roundAmountLabel,
              onTextChanged: (value) {
                rounds = value;
              },
            ),
            DoubleField(
              initialValueMin: roundMin,
              initialValueSec: roundSec,
              label: ref.read(appLocalizationsProvider).roundDurationLabel,
              onTextChangedMin: (value) {
                roundMin = value;
              },
              onTextChangedSec: (value) {
                roundSec = value;
              },
            ),
            DoubleField(
              initialValueMin: restMin,
              initialValueSec: restSec,
              label: ref.read(appLocalizationsProvider).restDurationLabel,
              onTextChangedMin: (value) {
                restMin = value;
              },
              onTextChangedSec: (value) {
                restSec = value;
              },
            ),
            SingleField(
              initialValue: delay,
              label: ref.read(appLocalizationsProvider).delayDurationLabel,
              onTextChanged: (value) {
                delay = value;
              },
            ),
            SingleField(
              initialValue: roundWarning,
              label: ref.read(appLocalizationsProvider).roundWarningLabel,
              onTextChanged: (value) {
                roundWarning = value;
              },
            ),
            SingleField(
              initialValue: restWarning,
              label: ref.read(appLocalizationsProvider).restWarningLabel,
              onTextChanged: (value) {
                restWarning = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: FilledButton.icon(
                onPressed: () {
                  startCountDown(context);
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(ref.read(appLocalizationsProvider).startLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startCountDown(BuildContext context) {
    var data = TimerData(
        rounDuration: calcRound(),
        rest: calcRest(),
        rounds: rounds,
        delay: delay,
        restWarning: restWarning,
        roundWarning: roundWarning);

    List<IntervalModel> intervals = [];
    if (delay > 0) {
      intervals.add(IntervalModel(
        duration: delay,
        type: IntervalType.delay,
        warning: data.roundWarning,
      ));
    }
    for (var i = 0; i < rounds; i++) {
      intervals.add(IntervalModel(
        duration: data.rounDuration,
        type: IntervalType.round,
        warning: data.roundWarning,
      ));
      if (i != rounds) {
        intervals.add(IntervalModel(
          duration: data.rest,
          type: IntervalType.rest,
          warning: data.restWarning,
        ));
      }
    }
    intervals.remove(intervals.last);

    context.push(TimerScreen.path, extra: intervals);
  }
}