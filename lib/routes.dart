import 'package:go_router/go_router.dart';
import 'package:training_timer/ui/screens/fighters_screen.dart';
import 'package:training_timer/ui/screens/finished_screen.dart';
import 'package:training_timer/ui/screens/setup_screen.dart';
import 'package:training_timer/ui/screens/timer_screen.dart';

import 'model/interval_model.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'fighters',
      path: FightersScreen.path,
      builder: (context, state) => const FightersScreen(),
    ),
    GoRoute(
      name: 'setup',
      path: SetupTimerScreen.path,
      builder: (context, state) => const SetupTimerScreen(),
    ),
    GoRoute(
      name: 'finished',
      path: FinishedScreen.path,
      builder: (context, state) => const FinishedScreen(),
    ),
    GoRoute(
      name: 'timer',
      path: TimerScreen.path,
      builder: (context, state) =>
          TimerScreen(intervals: state.extra as List<IntervalModel>),
    ),
  ],
);
