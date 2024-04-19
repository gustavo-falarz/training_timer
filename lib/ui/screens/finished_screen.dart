import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:training_timer/locale/localization.dart';

class FinishedScreen extends ConsumerWidget {
  const FinishedScreen({super.key});

  static const path = '/finished';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ref.read(appLocalizationsProvider).labelDone,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(50.0),
            const AnimatedEmoji(
              size: 180.0,
              source: AnimatedEmojiSource.asset,
              AnimatedEmojis.fireworks,
            ),
            const Gap(50.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: FloatingActionButton.extended(
                label: Text(
                  ref.read(appLocalizationsProvider).labelRemake,
                  style: const TextStyle(fontSize: 18.0),
                ),
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
