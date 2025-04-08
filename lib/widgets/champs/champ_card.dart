import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChampCard extends HookConsumerWidget {

  final champ;

  ChampCard({required this.champ});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Text("${champ.specificite.nom}"),
    );
  }
}