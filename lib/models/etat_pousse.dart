import 'package:flutter/material.dart';

enum EtatPousse {
  EnCours(
    nom: "En cours",
    message: "Attendez, le fruit n'est pas mûr 🤔",
    icon: Icon(Icons.access_time_rounded, color: Colors.blueGrey,),
    penalite: 1.0
  ),
  Termine(
    nom: "Terminé",
    message: "Bonne récolte, fruit parfait 😎",
    icon: Icon(Icons.check_circle_outline, color: Colors.green,),
    penalite: 1.0
  ),
  Depasse(
    nom: "Dépassé",
      message: "Récolte correct, le fruit est en bonne état 😃",
      icon: Icon(Icons.running_with_errors_outlined, color: Colors.orange,),
    penalite: 0.8
  ),
  Abime(
      nom: "Lente",
      message: "Récolte trop lente, le fruit est abimé ☹️",
      icon: Icon(Icons.error_outline, color: Colors.red,),
    penalite: 0.5,
  ),
  Perime(
    nom: "Périmé",
    message: "Mauvaise récolte, le fruit est fanée 😨️",
    icon: Icon(Icons.delete, color: Colors.black54,),
    penalite: 0.2,
  );

  final String nom;
  final Icon icon;
  final String message;
  final num penalite;

  const EtatPousse({
    required this.nom,
    required this.icon,
    required this.message,
    required this.penalite,
  });


}
