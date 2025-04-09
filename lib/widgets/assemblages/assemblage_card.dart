import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/models/assemblage.dart';
import 'package:kafe/models/champ.dart';
import 'package:kafe/providers/assemblage_stream_provider.dart';
import 'package:kafe/providers/champ_stream_provider.dart';
import 'package:kafe/widgets/gato/gato_stat_card.dart';
import 'package:kafe/widgets/modales/modale_plantation.dart';
import 'package:kafe/widgets/pousses/pousse_card.dart';
import 'package:intl/intl.dart';


import '../../models/kafe.dart';
import '../../providers/firebase_auth_provider.dart';

class AssemblageCard extends HookConsumerWidget {
  final Assemblage assemblage;

  AssemblageCard({required this.assemblage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void inscrire() {}

    void supprimer() async {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Confirmation"),
              content: Text("Voulez-vous vraiment supprimer cet assemblage ?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Annuler"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Confirmer"),
                ),
              ],
            ),
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
            //leading: Icon(Icons.album),
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
                        Theme.of(context).colorScheme.error,
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
