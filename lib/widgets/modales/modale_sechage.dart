// Dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/providers/firebase_auth_provider.dart';

import '../../models/kafe.dart';

class ModaleSechage extends HookConsumerWidget {
  final Kafe kafe;
  final num maxAmount;

  ModaleSechage({super.key, required this.kafe, required this.maxAmount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAmount = useState(0.0);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(kafe.nom), subtitle: Text("Séchage")),
          ListTile(
            title: Text('Sélectionner la quantité'),
            subtitle: Text("Maximum : ${maxAmount.toStringAsFixed(2)} Kg"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Slider(
                  value: selectedAmount.value,
                  min: 0.0,
                  max: maxAmount.toDouble(),
                  divisions: 100,
                  label: selectedAmount.value.toStringAsFixed(2),
                  onChanged: (double value) {
                    selectedAmount.value = value;
                  },
                ),
                Text(
                  "Quantité de fruit à sécher : ${selectedAmount.value.toStringAsFixed(2)} Kg",
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Annuler"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () {
                            if(selectedAmount.value > 0) {
                              ref
                                .watch(firebaseAuthProvider.notifier)
                                .updateSechage(kafe, selectedAmount.value);
                            }
                            Navigator.pop(context);
                          },
                          child: Text("Sécher"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 128.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showSechageModal(BuildContext context, Kafe kafe, num maxAmount) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return ModaleSechage(kafe: kafe, maxAmount: maxAmount);
    },
  );
}
