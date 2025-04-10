
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Delete1ssemblageAlert extends StatelessWidget {
  const Delete1ssemblageAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmation"),
      content: Text("Voulez-vous vraiment supprimer cet assemblage ?"),
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
