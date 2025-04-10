import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/enums/kafe.dart';

class FruitCard extends HookConsumerWidget {
  final Kafe kafe;
  final num poid;
  final Function onPressed;

  const FruitCard({
    super.key,
    required this.kafe,
    required this.poid,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(kafe.nom),
        subtitle: Text("Quantité : ${poid.toStringAsFixed(2)} Kg"),
        trailing: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () => onPressed(),
          child: Text("Sécher"),
        ),
      ),
    );
  }
}
