import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:training_timer/locale/localization.dart';
import 'package:training_timer/model/fighter_model.dart';

import '../../providers.dart';

class FightersScreen extends ConsumerStatefulWidget {
  const FightersScreen({super.key});

  static const String path = '/fighters';

  @override
  ConsumerState<FightersScreen> createState() => _FightersScreenState();
}

class _FightersScreenState extends ConsumerState<FightersScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Fighter> fighters = ref.watch(fightersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(appLocalizationsProvider).titleAddFighters),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                const Gap(10.0),
                Expanded(
                  flex: 1,
                  child: IconButton.filledTonal(
                    onPressed: () {
                      _addFighter();
                    },
                    icon: const Icon(Icons.add),
                  ),
                )
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: fighters.length,
              itemBuilder: (context, index) {
                Fighter fighter = fighters[index];
                return ListTile(
                  leading: Text(
                    fighter.id.toString(),
                  ),
                  title: Text(fighter.name),
                  trailing: IconButton(
                    onPressed: () {
                      _removeFighter(fighter);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _addFighter() {
    int id = ref.watch(fighterId);
    String fighterName = _controller.text;
    if (fighterName.isNotEmpty) {
      setState(() {
        Fighter f = Fighter(id: id, name: fighterName);
        ref.watch(fightersProvider.notifier).addFighter(f);
        ref.watch(fighterId.notifier).update(
              (state) => id + 1,
            );
        _controller.clear();
      });
    }
  }

  void _removeFighter(Fighter fighter) {
    setState(() {
      ref.watch(fightersProvider.notifier).removeFighter(fighter);
      _controller.clear();
    });
  }
}
