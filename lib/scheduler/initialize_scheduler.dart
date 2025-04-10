import 'package:cron/cron.dart';
import 'package:kafe/models/competition.dart';
import 'package:kafe/providers/competition_stream_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/assemblage_stream_provider.dart';

void initializeScheduler(WidgetRef ref) {
  final cron = Cron();

  cron.schedule(Schedule.parse('19 * * * *'), () async {
    final fetchCompetitions =
    await ref
        .read(competitionStreamProvider.notifier)
        .fetchCompetitions()
        .first;

    final now = DateTime.now();

    final hasActiveCompetition = fetchCompetitions.any((competition) {
      final competitionEndTime = competition.dateEpreuve.add(
        const Duration(minutes: 19),
      );
      return now.isBefore(competitionEndTime);
    });

    if (hasActiveCompetition) {
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

      await ref.watch(competitionStreamProvider.notifier).FindWinners(
          newCompetition);
    });
  });
}