import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:training_timer/routes.dart';
import 'package:training_timer/ui/theme/color_schemes.g.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    KeepScreenOn.turnOn();
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      darkTheme: ThemeData(colorScheme: darkColorScheme),
      theme: ThemeData(colorScheme: lightColorScheme),
      themeMode: ref.watch(themeProvider),
    );
  }
}

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
