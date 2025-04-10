import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecompenseAlert extends ConsumerWidget {
  const RecompenseAlert({
    super.key,
    required this.deevee,
    required this.goldenSeed,
  });

  final int deevee;
  final int goldenSeed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      confettiController.play();
    });

    return Stack(
      alignment: Alignment.center,
      children: [
        ConfettiWidget(
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          minBlastForce: 35,
          maxBlastForce: 55,
          emissionFrequency: .75,
          numberOfParticles: 15,
          shouldLoop: false,
          colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow],
        ),
        // AlertDialog
        AlertDialog(
          title: Center(child: Text("Félicitation !")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Vous avez obtenu :", style: TextStyle(fontSize: 16)),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${deevee} 💎", style: TextStyle(fontSize: 24)),
                    Text("${goldenSeed} 🪙", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                confettiController.dispose();
                Navigator.of(context).pop();
              },
              child: Text("Accepter"),
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ],
    );
  }
}
