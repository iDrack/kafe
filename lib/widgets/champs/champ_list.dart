import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/champ.dart';
import '../../providers/champ_stream_provider.dart';
import '../../providers/firebase_auth_provider.dart';
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
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 46.0,
                ),
                child: ChampCard(champ: champ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 76.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0xFF9CCC65),
                  ),
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
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
                      return AlertDialog(
                        title: Text("Acheter un nouveau champ"),
                        content: Text(
                          "Voulez-vous acheter un champ pour 10💎 ?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Annuler"),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .watch(champStreamProvider.notifier)
                                  .add(Champ(userId: user.uuid));
                              ref
                                  .watch(firebaseAuthProvider.notifier)
                                  .updateDeevee(10);
                              Navigator.of(context).pop();
                            },
                            child: Text("Accepter"),
                          ),
                          SizedBox(height: 32.0),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Acheter un champ",
                        style: TextStyle(fontSize: 18.0),
                      ),
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
