
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/widgets/graines/graine_card.dart';

import '../../models/app_user.dart';
import '../../models/enums/kafe.dart';

class GraineList extends HookConsumerWidget {
  final AppUser user;

  const GraineList({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        Kafe.values.map((kafe) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GraineCard(
              kafe: kafe,
              poid: user.quantiteGraine[kafe] ?? 0.0,
            ),
          );
        }).toList(),
      ),
    );
  }
}
