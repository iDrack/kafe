import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kafe/models/app_user.dart';
import 'package:kafe/models/competition.dart';
import 'package:kafe/providers/competition_stream_provider.dart';
import 'package:kafe/providers/firebase_auth_provider.dart';
import 'package:kafe/widgets/alerts/recompense_alert.dart';

import '../../models/enums/kafe.dart';

class CompetitionCard extends HookConsumerWidget {
  final Competition competition;

  const CompetitionCard({super.key,
    required this.competition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final rewards = useState({"deevee": 0, "goldenSeed": 0});
    AppUser? user = ref.read(userProvider.state).state;

    Future<void> collectRewards() async {
      rewards.value = await ref.watch(competitionStreamProvider.notifier).claimReward(competition, user!.uuid);
      showDialog(context: context, builder: (BuildContext context) {
        return RecompenseAlert(deevee: rewards.value["deevee"] ?? 0, goldenSeed: rewards.value['goldenSeed'] ?? 0,);
      },);
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Victoire !"),
            subtitle: Text('Le ${DateFormat("dd/MM/yyyy à HH:mm").format(competition.dateEpreuve)}'),
            trailing: Icon(Icons.emoji_events, color: Color(0xFFd8cf1c),)
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),
            ),
            onPressed: () => collectRewards() ,
            child: Text("Réclamer vos récompenses"),
          ),
          SizedBox(height: 8.0,),
        ],
      ),
    );
  }
}
