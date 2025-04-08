import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/champ.dart';
import 'champ_card.dart';

class ChampList extends HookConsumerWidget {
  List<Champ> champs;

  ChampList({super.key, required this.champs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return champs.isEmpty
        ? Center(
      child: Text(
        "Rien à afficher.",
      ),
    )
        : ListView(
      shrinkWrap: true,
      children: champs
          .map((champ) => Padding(
        padding: const EdgeInsets.all(8),
        child: ChampCard(
          champ: champ,
        ),
      ))
          .toList(),
    );
  }
}