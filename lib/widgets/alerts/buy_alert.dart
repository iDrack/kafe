import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe/widgets/alerts/confirmation_text_widget.dart';
import 'package:lottie/lottie.dart';

import '../../models/app_user.dart';
import '../../models/champ.dart';
import '../../providers/champ_stream_provider.dart';
import '../../providers/firebase_auth_provider.dart';

class BuyAlert extends ConsumerWidget {
  const BuyAlert({super.key, required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Center(child: Text("Acheter un champ ?")),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConfirmationTextWidget(title: "Voulez-vous acheter un champ pour 10💎 ?"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Annuler"),
        ),
        TextButton(
          onPressed: () {
            ref
                .watch(champStreamProvider.notifier)
                .add(Champ(userId: user!.uuid));
            ref.watch(firebaseAuthProvider.notifier).updateDeevee(-10);
            Navigator.of(context).pop();
          },
          child: Text("Acheter"),
        ),
        SizedBox(height: 32.0),
      ],
    );
  }
}
