import 'package:flutter/material.dart';
        import 'package:flutter_riverpod/flutter_riverpod.dart';

        import '../../models/competition.dart';
        import '../../providers/assemblage_stream_provider.dart';
        import '../../providers/competition_stream_provider.dart';

        class CompetitionCreationButton extends ConsumerWidget {
          const CompetitionCreationButton({super.key});

          @override
          Widget build(BuildContext context, WidgetRef ref) {
            return IconButton(
              icon: Image.asset(
                'lib/assets/logos/chitKafeLogo.png',
                width: 24,
                height: 24,
              ),
              onPressed: () async {
                final fetchCompetitions =
                    await ref
                        .read(competitionStreamProvider.notifier)
                        .fetchCompetitions()
                        .first;

                final now = DateTime.now();

                // Vérification des compétitions actives
                final hasActiveCompetition = fetchCompetitions.any((competition) {
                  final competitionEndTime = competition.dateEpreuve.add(
                    const Duration(minutes: 19),
                  );
                  return now.isBefore(competitionEndTime);
                });

                if (hasActiveCompetition) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Une compétition est déjà active. Veuillez attendre qu'elle se termine avant d'en créer une nouvelle.",
                      ),
                    ),
                  );
                  return;
                }

                final inscritsStream =
                    ref
                        .read(assemblageStreamProvider.notifier)
                        .fetchAllAssemblageInscrit();

                inscritsStream.listen((inscrits) async {
                  if (inscrits.isEmpty) {
                    return;
                  }

                  final newCompetition = Competition(
                    assemblageParticipants: inscrits,
                    dateEpreuve: DateTime.now(),
                  );

                  newCompetition.id = await ref
                      .read(competitionStreamProvider.notifier)
                      .add(newCompetition);

                  await ref
                      .watch(competitionStreamProvider.notifier)
                      .FindWinners(newCompetition);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nouvelle compétition créée !")),
                  );
                });
              },
            );
          }
        }