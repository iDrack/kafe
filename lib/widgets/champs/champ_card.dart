import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/models/champ.dart';
import 'package:kafe/models/pousse.dart';
import 'package:kafe/providers/champ_stream_provider.dart';
import 'package:kafe/widgets/modales/modale_plantation.dart';

import '../../models/kafe.dart';

class ChampCard extends HookConsumerWidget {
  final Champ champ;

  ChampCard({required this.champ});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> createPlan(int position, Kafe kafe) async {
      Pousse pousse = Pousse(kafe: kafe, dateFinPrevu: DateTime.now().add(kafe.tempsDePousse));
      champ.plans[position].pousse = pousse;
      ref.watch(champStreamProvider.notifier).updateChamp(champ);
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            //leading: Icon(Icons.album),
            title: Text('Champ'),
            subtitle: Text('Bonus : ${champ.specificite.nom}'),
          ),
          ListView(
            shrinkWrap: true,
            children:
                champ.plans.map((plan) {
                  if (plan.pousse == null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor,
                                ),
                                foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
                              ),
                              child: const Icon(Icons.add),
                              onPressed: () {
                                showPlantationModal(context, Kafe.values, (selectedKafe) {
                                  int index = champ.plans.indexOf(plan);
                                  createPlan(index, selectedKafe);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('${plan}'),
                    );
                  }

                }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text('Récolter'),
                onPressed: () {
                  /* ... */
                },
              ),
              const SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
