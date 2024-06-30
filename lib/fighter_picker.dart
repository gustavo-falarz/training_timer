import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_timer/model/fighter_model.dart';
import 'package:training_timer/providers.dart';

import 'model/match_model.dart';

List<MatchModel> pickMatches(WidgetRef ref){
  List<MatchModel> matches = [];
  List<Fighter> fighters = [];
  fighters.addAll(ref.watch(fightersProvider));


  List list = List.generate(fighters.length, (i) => i);
  list.shuffle();

  for (var i = 0; i < fighters.length; i = i+2) {
    int f1  = list[i];
    int f2  =  list[i+1];
    Fighter fighter1 = fighters[f1];
    Fighter fighter2 = fighters[f2];
    MatchModel match = MatchModel(
      fighter1,
      fighter2,
    );
    matches.add(match);
  }
  ref.watch(matchesProvider.notifier).addMatch(matches);
  return matches;
}