
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteInscriptionAlert extends StatelessWidget {
  const DeleteInscriptionAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmation"),
      content: Text("Voulez-vous vraiment retirer l'inscription cet assemblage ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Annuler"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text("Confirmer"),
        ),
      ],
    );
  }
}