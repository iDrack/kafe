import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/models/competition.dart';
import 'package:kafe/providers/competition_stream_provider.dart';
import 'package:kafe/widgets/competition/competition_card.dart';
import 'package:kafe/widgets/lotti/loading_coffee_widget.dart';
import 'package:kafe/widgets/lotti/not_found_widget.dart';

import '../../providers/firebase_auth_provider.dart';

class CompetitionList extends HookConsumerWidget {
  const CompetitionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final fetchCompetitions = ref
        .watch(competitionStreamProvider.notifier)
        .fetchCompetitionsIfUserWon(user!.uuid);
    return StreamBuilder<List<Competition>>(
      stream: fetchCompetitions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingCoffeeWidget());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          final competitions = snapshot.data!;
          if (competitions.isEmpty) {
            return Center(
              child: NotFoundWidget(title: "Vous n'avez aucune récompense en attente."),
            );
          }
          return ListView(
            shrinkWrap: true,
            children: [
              ...competitions.map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 32.0,
                  ),
                  child: CompetitionCard(competition: c),
                ),
              ),
            ],
          );
        }
        return Center(child: Text("Vous n'avez aucune récompense en attente."));
      },
    );
  }
}
