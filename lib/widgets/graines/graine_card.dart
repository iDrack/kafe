import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/kafe.dart';

class GraineCard extends HookConsumerWidget {
  final Kafe kafe;
  final num poid;

  const GraineCard({super.key,
    required this.kafe,
    required this.poid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(kafe.nom),
        subtitle: Text("Quantité : ${poid.toStringAsFixed(2)} Kg"),

      ),
    );
  }
}
