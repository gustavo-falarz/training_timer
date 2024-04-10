import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const Locale fallbackLocale = Locale('en', 'US');

final localeStateProvider = StateNotifierProvider<LocaleStateNotifier, Locale>(
    (ref) => LocaleStateNotifier(ref));

class LocaleStateNotifier extends StateNotifier<Locale> {
  LocaleStateNotifier(this.ref) : super(fallbackLocale);

  final Ref ref;

  void setLocale(locale) {
    state = locale;
  }
}