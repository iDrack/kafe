import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/providers/assemblage_stream_provider.dart';
import 'package:kafe/widgets/assemblages/assemblage_card.dart';
import '../../models/assemblage.dart';
import '../../providers/firebase_auth_provider.dart';
import 'new_assemblage_button.dart';

class AssemblageList extends HookConsumerWidget {
  const AssemblageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final fetchAssemblages = ref
                .watch(assemblageStreamProvider.notifier)
                .fetchAssemblages(user!.uuid);

    return StreamBuilder<List<Assemblage>>(
      stream: fetchAssemblages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          final assemblages = snapshot.data!;
          if (assemblages.isEmpty) {
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Aucun Assemblage de disponible."),
                SizedBox(height: 8.0),
                NewAssemblageButton(context: context,),
              ],
            ));
          }
          return ListView(
            shrinkWrap: true,
            children: [
              ...assemblages.map(
                (a) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 32.0,
                  ),
                  child: AssemblageCard(assemblage: a),
                ),
              ),
              NewAssemblageButton(context: context,),
            ],
          );
        }
        return Center(child: NewAssemblageButton(context: context,));
      },
    );
  }
}
