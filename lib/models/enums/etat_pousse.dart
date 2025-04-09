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
    message: "Récolte parfaite 😎 :",
    icon: Icon(Icons.check_circle_outline, color: Colors.green,),
    penalite: 1.0
  ),
  Depasse(
    nom: "Dépassé",
      message: "Récolte correct 😃 :",
      icon: Icon(Icons.running_with_errors_outlined, color: Color(0xFFd8cf1c),),
    penalite: 0.8
  ),
  Abime(
      nom: "Lente",
      message: "Récolte trop lente ☹️ :",
      icon: Icon(Icons.error_outline, color: Colors.orange,),
    penalite: 0.5,
  ),
  Perime(
    nom: "Périmé",
    message: "Mauvaise récolte 😨️ :",
    icon: Icon(Icons.new_releases_outlined, color: Colors.redAccent,),
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
