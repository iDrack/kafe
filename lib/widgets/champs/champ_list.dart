import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/champ.dart';
import '../../providers/firebase_auth_provider.dart';
import '../alerts/buy_alert.dart';
import 'champ_card.dart';

class ChampList extends HookConsumerWidget {
  final List<Champ> champs;

  const ChampList({super.key, required this.champs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      shrinkWrap: true,
      children: [
        ...champs.map(
          (champ) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32.0),
            child: ChampCard(champ: champ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 76.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF9CCC65)),
              foregroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              final user = ref.watch(userProvider);
              if (user!.deevee < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Vous n'avez pas assez de 💎 pour acheter un champ.",
                    ),
                  ),
                );
                return;
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BuyAlert(user: user);
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Acheter un champ", style: TextStyle(fontSize: 18.0)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
