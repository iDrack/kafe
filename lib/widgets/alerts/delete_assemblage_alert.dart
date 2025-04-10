import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafe/widgets/alerts/confirmation_text_widget.dart';

class Delete1ssemblageAlert extends StatelessWidget {
  const Delete1ssemblageAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Êtes-vous sûr ?")),
      content: ConfirmationTextWidget(title: "Voulez-vous supprimer cet assemblage ?"),
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
