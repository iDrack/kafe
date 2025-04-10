import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/widgets/fruits/fruit_card.dart';
import 'package:kafe/widgets/modales/modale_sechage.dart';

import '../../models/app_user.dart';
import '../../models/enums/kafe.dart';

class FruitList extends HookConsumerWidget {
  final AppUser user;

  const FruitList({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void secher(Kafe kafe, num maxAmount) {
      if (maxAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous n\'avez pas de ${kafe.name}')),
        );
      } else {
        showSechageModal(context, kafe, maxAmount);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            Kafe.values.map((kafe) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FruitCard(
                  kafe: kafe,
                  poid: user.quantiteKafe[kafe] ?? 0.0,
                  onPressed: () => secher(kafe, user.quantiteKafe[kafe] ?? 0.0),
                ),
              );
            }).toList(),
      ),
    );
  }
}
