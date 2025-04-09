// Dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/providers/assemblage_stream_provider.dart';
import 'package:kafe/providers/firebase_auth_provider.dart';

import '../../models/assemblage.dart';
import '../../models/enums/kafe.dart';

class ModaleAssemblage extends HookConsumerWidget {
  ModaleAssemblage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final Map<Kafe, num> quantiteGraine =
        user?.quantiteGraine ??
        {
          Kafe.Rubisca: 0.0,
          Kafe.Goldoriat: 0.0,
          Kafe.Roupetta: 0.0,
          Kafe.Tourista: 0.0,
          Kafe.Arbrista: 0.0,
        };

    final poidTotal = useState(0.0);

    final selectedQuantiteGraine = useState({
      Kafe.Rubisca: 0.0,
      Kafe.Goldoriat: 0.0,
      Kafe.Roupetta: 0.0,
      Kafe.Tourista: 0.0,
      Kafe.Arbrista: 0.0,
    });

    useEffect(() {
      double total = 0.0;
      selectedQuantiteGraine.value.forEach((key, value) {
        total += value;
      });
      poidTotal.value = total;
      return;
    }, [selectedQuantiteGraine.value]);

    void creerAssemblage() {
      if (poidTotal.value > 0) {
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la création de l\'assemblage'),
            ),
          );
        } else {
          for (var item in selectedQuantiteGraine.value.entries) {
            if (item.value > 0) {
              ref
                  .watch(firebaseAuthProvider.notifier)
                  .updateSechage(item.key, -item.value);
            }
          }

          ref
              .watch(assemblageStreamProvider.notifier)
              .add(
                Assemblage(
                  userId: user.uuid,
                  quantiteKafe: selectedQuantiteGraine.value,
                ),
              );
        }
        Navigator.pop(context);
      }
    }

    void resetValue() {
      selectedQuantiteGraine.value = {
        Kafe.Rubisca: 0.0,
        Kafe.Goldoriat: 0.0,
        Kafe.Roupetta: 0.0,
        Kafe.Tourista: 0.0,
        Kafe.Arbrista: 0.0,
      };
    }

    void randomValues() {
      selectedQuantiteGraine.value = {
        Kafe.Rubisca: Random().nextDouble() *( quantiteGraine[Kafe.Rubisca]?.toDouble() ?? 0.0),
        Kafe.Goldoriat:Random().nextDouble() *( quantiteGraine[Kafe.Goldoriat]?.toDouble() ?? 0.0),
        Kafe.Roupetta: Random().nextDouble() *( quantiteGraine[Kafe.Roupetta]?.toDouble() ?? 0.0),
        Kafe.Tourista: Random().nextDouble() *( quantiteGraine[Kafe.Tourista]?.toDouble() ?? 0.0),
        Kafe.Arbrista: Random().nextDouble() *( quantiteGraine[Kafe.Arbrista]?.toDouble() ?? 0.0),
      };
    }

    return Card(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Créer un assemblage"),
                subtitle: Text(
                  "Faites un assemblage d'au moins 1Kg pour participer à une compétition.",
                ),
              ),
              ...quantiteGraine.entries.map((item) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(item.key.nom),
                      subtitle: Text(
                        '${selectedQuantiteGraine.value[item.key]?.toStringAsFixed(2) ?? 00.00}/${item.value.toDouble().toStringAsFixed(2)} Kg',
                      ),
                    ),
                    Column(
                      children: [
                        Slider(
                          value: selectedQuantiteGraine.value[item.key]!,
                          min: 0.0,
                          max: item.value.toDouble(),
                          divisions: 100,
                          label: selectedQuantiteGraine.value[item.key]!
                              .toStringAsFixed(2),
                          onChanged: (double value) {
                            selectedQuantiteGraine.value = {
                              ...selectedQuantiteGraine.value,
                              item.key: value,
                            };
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }),
              Text("Poid total : ${poidTotal.value.toStringAsFixed(2)} Kg"),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: IconButton(
                        onPressed: () => resetValue(),
                        icon: Icon(Icons.restart_alt, color: Colors.black38,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
                      child: IconButton(
                        onPressed: () => randomValues(),
                        icon: Icon(Icons.shuffle, color: Colors.black38,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4.0,8.0,8.0,8.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Annuler"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        onPressed: () => creerAssemblage(),
                        child: Text("Créer"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}

void showAssemblageModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: ModaleAssemblage(),
      );
    },
  );
}
