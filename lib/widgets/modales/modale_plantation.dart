import 'package:flutter/material.dart';

import '../../models/enums/kafe.dart';

class ModalePlantation extends StatelessWidget {
  final List<Kafe> kafes;
  final Function(Kafe) onKafeSelected; // Callback pour la sélection

  const ModalePlantation({required this.kafes, required this.onKafeSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Center(
            child: Text(
              "Choisissez votre kafé :",
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: kafes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(kafes[index].nom),
                subtitle: Text(
                  "Prix ${kafes[index].prix} 💎\nTemps de pousse : ${(kafes[index].tempsDePousse / 60).toStringAsFixed(0)} min\nRendement attendu : ${kafes[index].tailleProductionInitial} Kg.",
                ),
                onTap: () {
                  onKafeSelected(kafes[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

void showPlantationModal(
  BuildContext context,
  List<Kafe> kafes,
  Function(Kafe) onKafeSelected,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.65,
        child: ModalePlantation(kafes: kafes, onKafeSelected: onKafeSelected),
      );
    },
  );
}
