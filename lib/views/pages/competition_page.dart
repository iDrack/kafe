import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/widgets/graines/graine_list.dart';
import 'package:kafe/widgets/inscrit/inscrit_container.dart';

import '../../models/app_user.dart';

class CompetitionPage extends HookConsumerWidget {
  final AppUser user;
  const CompetitionPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2, // Nombre d'onglets
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: "Inscription"),
            Tab(text: "Résultats"),
          ],
        ),
        body: TabBarView(
          children: [
            InscritContainer(),
            GraineList(user: user),
          ],
        ),
      ),
    );
  }
}