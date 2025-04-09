import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/widgets/fruits/fruit_list.dart';
import 'package:kafe/widgets/graines/graine_list.dart';

import '../../models/app_user.dart';

class StockPage extends HookConsumerWidget {
  final AppUser user;
  const StockPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3, // Nombre d'onglets
      child: Scaffold(
        appBar: TabBar(
            tabs: [
              Tab(text: "Fruits"),
              Tab(text: "Graines"),
              Tab(text: "Assemblages"),
            ],
          ),
        body: TabBarView(
          children: [
            FruitList(user: user),
            GraineList(user: user),
            Center(child: Text("Contenu des Assemblages")),
          ],
        ),
      ),
    );
  }
}