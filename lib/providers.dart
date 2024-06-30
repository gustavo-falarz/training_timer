import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_timer/model/fighter_model.dart';
import 'package:training_timer/model/match_model.dart';


final fighterId = StateProvider<int>((ref) => 1);
final pastMatches = StateProvider<List<String>>((ref) => []);

final fightersProvider = StateNotifierProvider<FightersNotifier, List<Fighter>>((ref) {
  return FightersNotifier();
});

class FightersNotifier extends StateNotifier<List<Fighter>> {
  FightersNotifier() : super([]);

  void addFighter(Fighter f) => state.add(f);

  void removeFighter(Fighter f) {
    state.remove(f);
  }
}

final matchesProvider = StateNotifierProvider<MatchesNotifier, List<MatchModel>>((ref) {
  return MatchesNotifier();
});

class MatchesNotifier extends StateNotifier<List<MatchModel>> {
  MatchesNotifier() : super([]);

  void addMatch(List<MatchModel> f) => state = f;

  void clearMatches() {
    state.clear();
  }
}
