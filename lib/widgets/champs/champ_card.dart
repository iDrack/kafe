import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/models/champ.dart';
import 'package:kafe/providers/champ_stream_provider.dart';
import 'package:kafe/widgets/modales/modale_plantation.dart';
import 'package:kafe/widgets/pousses/pousse_card.dart';

import '../../models/kafe.dart';

class ChampCard extends HookConsumerWidget {
  final Champ champ;

  ChampCard({required this.champ});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> createPlan(int position, Kafe kafe) async {
      champ.plans[position].kafe = kafe;
      champ.plans[position].datePlantation = DateTime.now();
      ref.watch(champStreamProvider.notifier).updateChamp(champ);
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            //leading: Icon(Icons.album),
            title: Text('Champ ${champ.specificite.name}'),
            subtitle: Text('Bonus : ${champ.specificite.nom}'),
          ),
          ListView(
            shrinkWrap: true,
            children:
                champ.plans.map((plan) {
                  if (plan.kafe == null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextButton(
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
                      child: PousseCard(planIndex: champ.plans.indexOf(plan), champ: champ, kafe: plan.kafe, datePlantation: plan.datePlantation,),
                    );
                  }

                }).toList(),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
