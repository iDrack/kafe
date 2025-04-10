import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kafe/models/assemblage.dart';
import 'package:kafe/providers/assemblage_stream_provider.dart';
import 'package:kafe/widgets/gato/gato_stat_card.dart';

import '../alerts/delete_assemblage_alert.dart';

class AssemblageCard extends HookConsumerWidget {
  final Assemblage assemblage;

  AssemblageCard({required this.assemblage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void inscrire() async {
      if(assemblage.poid < 1.00) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Un assemblage doit faire plus d'1Kg pour concourir. 😮‍💨"
            ),
          ),
        );
      } else {
        await ref.watch(assemblageStreamProvider.notifier).setAssemblageInscrit(assemblage);
      }
    }

    void supprimer() async {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => Delete1ssemblageAlert(),
      );

      if (confirmed == true) {
        ref
            .read(assemblageStreamProvider.notifier)
            .deleteAssemblage(assemblage);
      }
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Assemblage'),
            subtitle: Text('Créer le : ${DateFormat("dd/MM/yyyy à HH:mm").format(assemblage.createdAt)}'),          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children:
                  assemblage.gato.entries.map((item) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GatoStatCard(title: item.key, value: item.value),
                    );
                  }).toList(),
            ),
          ),
          Text("Poid : ${assemblage.poid.toStringAsFixed(2)} Kg"),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.redAccent,
                      ),
                      foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () => supprimer(),
                    child: Text("Supprimer"),
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
                    onPressed: () => inscrire(),
                    child: Text("Inscrire"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
