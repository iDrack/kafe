import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/models/app_user.dart';
import 'package:kafe/models/champ.dart';
import 'package:kafe/providers/champ_stream_provider.dart';
import 'package:kafe/widgets/champs/champ_list.dart';

import '../../providers/firebase_auth_provider.dart';

class ChampFilteredList extends HookConsumerWidget {
  const ChampFilteredList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUser? user = ref.watch(userProvider);

    fetchChamps() {
      if(user == null) return null;
      return ref.watch(champStreamProvider.notifier).fetchChamps(user.uuid);
    }

    return StreamBuilder<List<Champ>>(
      stream: fetchChamps(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          return ChampList(champs: snapshot.data!);
        }
        return const Center(child: Text("Aucun champ n'éxiste."));
      },
    );
  }
}
