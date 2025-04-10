import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafe/widgets/alerts/confirmation_text_widget.dart';

class DeleteInscriptionAlert extends StatelessWidget {
  const DeleteInscriptionAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Êtes-vous sûr ?")),
      content: ConfirmationTextWidget(title: "Voulez-vous désinscrire cet assemblage du prochain concours ?"),
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