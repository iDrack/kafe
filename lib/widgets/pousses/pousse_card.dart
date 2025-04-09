import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/champ.dart';
import '../../models/enums/etat_pousse.dart';
import '../../models/enums/kafe.dart';
import '../../models/enums/specificite.dart';
import '../../models/plan.dart';
import '../../providers/champ_stream_provider.dart';
import '../../providers/firebase_auth_provider.dart';

class PousseCard extends HookConsumerWidget {
  final int planIndex;
  final Champ champ;
  final Kafe? kafe;
  final DateTime? datePlantation;

  PousseCard({
    super.key,
    required this.planIndex,
    required this.champ,
    required this.kafe,
    required this.datePlantation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kafe == null || datePlantation == null) {
      return const SizedBox();
    }

    final etatPousse = useState(EtatPousse.EnCours);

    final int tempsDePousseEffectif =
        champ.specificite == Specificite.Rapide
            ? (kafe!.tempsDePousse / 2).ceil()
            : kafe!.tempsDePousse;

    final initialRemainingTime = useState<int>(
      tempsDePousseEffectif -
          DateTime.now().difference(datePlantation!).inSeconds,
    );

    final remainingTime = useState<int>(initialRemainingTime.value);

    useEffect(() {
      Timer? timer;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final newRemainingTime =
            tempsDePousseEffectif -
            DateTime.now().difference(datePlantation!).inSeconds;

        if (newRemainingTime > 0) {
          remainingTime.value = newRemainingTime;

          champ.plans[planIndex].datePlantation = datePlantation;
          await ref.read(champStreamProvider.notifier).updateChamp(champ);
        } else {
          remainingTime.value = newRemainingTime;
          if (newRemainingTime <= 0 &&
              newRemainingTime > -tempsDePousseEffectif) {
            etatPousse.value = EtatPousse.Termine;
          } else if (newRemainingTime <= -tempsDePousseEffectif &&
              newRemainingTime > -tempsDePousseEffectif * 2) {
            etatPousse.value = EtatPousse.Depasse;
          } else if (newRemainingTime <= -tempsDePousseEffectif * 2 &&
              newRemainingTime > -tempsDePousseEffectif * 3) {
            etatPousse.value = EtatPousse.Depasse;
          } else if (newRemainingTime <= -tempsDePousseEffectif * 3 &&
              newRemainingTime > -tempsDePousseEffectif * 5) {
            etatPousse.value = EtatPousse.Abime;
          } else {
            etatPousse.value = EtatPousse.Perime;
            timer.cancel();
          }
        }
      });

      return timer.cancel;
    }, [remainingTime.value]);

    void recolter() {
      if (etatPousse.value == EtatPousse.EnCours) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${etatPousse.value.message}.')));
      } else {
        num poidRecolter =
            (kafe!.tailleProductionInitial *
                (champ.specificite == Specificite.Abondant ? 2 : 1)) *
            etatPousse.value.penalite;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${etatPousse.value.message} récolté $poidRecolter Kg de Kafé.',
            ),
          ),
        );
        ref
            .watch(firebaseAuthProvider.notifier)
            .updateQuantiteKafe(kafe!, poidRecolter);
        champ.plans[planIndex] = Plan();
        ref.read(champStreamProvider.notifier).updateChamp(champ);
      }
    }

    String formatTime(int seconds) {
      final minutes =
          seconds < 0 ? "00" : (seconds ~/ 60).toString().padLeft(2, '0');
      final secs =
          seconds < 0 ? "00" : (seconds % 60).toString().padLeft(2, '0');
      return "$minutes:$secs";
    }

    final progress = 1 - (remainingTime.value / tempsDePousseEffectif);

    return InkWell(
      onTap: recolter,
      child: Column(
        children: [
          ListTile(
            title: Text(kafe!.nom),
            subtitle: Text(
              "Temps restant : ${formatTime(remainingTime.value)}",
            ),
            trailing: (etatPousse.value.icon),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9CCC65)),
            ),
          ),
        ],
      ),
    );
  }
}
