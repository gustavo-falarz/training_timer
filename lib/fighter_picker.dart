import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_timer/model/fighter_model.dart';
import 'package:training_timer/providers.dart';

import 'model/match_model.dart';

void pickMatches(WidgetRef ref) {
  bool success = false;
  List<MatchModel> matches = [];
  List<Fighter> fighters = [];

  while (!success) {
    fighters.addAll(ref.watch(fightersProvider));

    int fightersThatFoughtEveryone = 0;
    for (Fighter f in fighters) {
      if (f.fought.length == fighters.length - 1) {
        fightersThatFoughtEveryone++;
      }
    }
    if (fightersThatFoughtEveryone == fighters.length) {
      ref.watch(fightersLeft).clear();
      ref.watch(fightersProvider.notifier).resetMatches();
    }

    try {
      Fighter? leftOut;
      List<Fighter> fightersLeftOut = ref.watch(fightersLeft);
      if (fighters.length.isOdd) {
        if (fightersLeftOut.length == fighters.length) {
          ref.watch(fightersLeft).clear();
        }

        List<Fighter> orderedFighters = [];
        orderedFighters.addAll(fighters);
        orderedFighters.sort((a, b) => a.id.compareTo(b.id));

        leftOut = orderedFighters[fightersLeftOut.length];

        // leftOut = fighters
        //     .firstWhere((element) => element.id == fightersLeftOut.length + 1);


        if (!fightersLeftOut.contains(leftOut)) {
          fighters.remove(leftOut);
        }
      }

      for (var i = 0; i < fighters.length; i = i++) {
        Fighter fighter1 = fighters[i];
        Fighter fighter2 = fighters.firstWhere((element) =>
            element != fighter1 && !fighter1.fought.contains(element));
        fighters.remove(fighter1);
        fighters.remove(fighter2);

        MatchModel match = MatchModel(
          fighter1,
          fighter2,
        );
        if (!fightersLeftOut.contains(leftOut) && leftOut != null) {
          ref.watch(fightersLeft).add(leftOut);
          ref.watch(fighterOutProvider.notifier).addFighter(leftOut);
        }
        matches.add(match);
      }
      success = true;
    } catch (e) {
      if (e is StateError) {
        ref.watch(fightersProvider.notifier).shuffle();
        matches.clear();
        fighters.clear();
        ref.watch(fightersLeft).removeLast();
        success = false;
      } else {
        success = true;
        throw e;
      }
    }
  }

  for (MatchModel m in matches) {
    m.updateFought();
  }
  ref.watch(matchesProvider.notifier).addMatch(matches);
}
