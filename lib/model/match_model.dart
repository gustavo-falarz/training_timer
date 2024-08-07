import 'package:training_timer/model/fighter_model.dart';

class MatchModel {
  Fighter fighter1;
  Fighter fighter2;

  MatchModel(this.fighter1, this.fighter2);

  @override
  String toString() {
    return '$fighter1 vs $fighter2';
  }

  void updateFought() {
    fighter1.fought.add(fighter2);
    fighter2.fought.add(fighter1);
  }
}
