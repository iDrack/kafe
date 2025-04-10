import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/providers/assemblage_stream_provider.dart';
import 'package:kafe/widgets/inscrit/assemblage_inscrit_card.dart';
import 'package:kafe/widgets/lotti/loading_coffee_widget.dart';

import '../../models/assemblage.dart';
import '../../providers/firebase_auth_provider.dart';

class InscritContainer extends HookConsumerWidget {
  const InscritContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final fetchAssemblageInscrit = ref
        .watch(assemblageStreamProvider.notifier)
        .fetchAssemblageInscrit(user!.uuid);

    return StreamBuilder<List<Assemblage>>(
      stream: fetchAssemblageInscrit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingCoffeeWidget());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          final assemblages = snapshot.data!;
          if (assemblages.isEmpty) {
            return Center(
              child: Text("Aucun assemblage inscrit au prochain concours."),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(
              child: AssemblageInscritCard(assemblage: assemblages.first),
            ),
          );
        } else {
          return Center(
            child: Text("Aucun assemblage inscrit au prochain concours."),
          );
        }
      },
    );
  }
}
