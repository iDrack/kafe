import 'package:flutter/material.dart';
            import 'package:hooks_riverpod/hooks_riverpod.dart';
            import 'package:kafe/models/assemblage.dart';
            import 'package:kafe/widgets/gato/gato_stat_card.dart';
            import 'package:intl/intl.dart';

            import '../../providers/assemblage_stream_provider.dart';

            class AssemblageInscritCard extends HookConsumerWidget {
              final Assemblage assemblage;

              const AssemblageInscritCard({super.key, required this.assemblage});

              @override
              Widget build(BuildContext context, WidgetRef ref) {
                void inscrire() {
                  ref.watch(assemblageStreamProvider.notifier).setAssemblageInscrit(assemblage);
                }

                void supprimer() async {
                  final bool? confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Confirmation"),
                      content: Text("Voulez-vous vraiment retirer l'inscription cet assemblage ?"),
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
                    assemblage.inscrit = false;
                    ref.read(assemblageStreamProvider.notifier).updateAssemblage(assemblage);
                  }
                }

                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('Inscription au prochain concours'),
                        subtitle: DateTime.now().minute >= 29
                            ? Text('Le concours aura lieu à : ${DateFormat("HH").format(DateTime.now().add(Duration(hours: 1)))}:29')
                            : Text('Le concours aura lieu à : ${DateFormat("HH").format(DateTime.now())}:29'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: assemblage.gato.entries.map((item) {
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
                                    Colors.redAccent,
                                  ),
                                  foregroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                onPressed: () => supprimer(),
                                child: Text("Supprimer l'inscription"),
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