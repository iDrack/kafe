import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modales/modale_assemblage.dart';

class NewAssemblageButton extends StatelessWidget {
  final BuildContext context;
  const NewAssemblageButton({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 76.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () => showAssemblageModal(context),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Assembler un assemblage")],
        ),
      ),
    );
  }
}
