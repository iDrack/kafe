enum Specificite {
  Neutre(nom: "Aucun"),
  Beaucoup(nom: "Rendement x2"),
  Rapide(nom: "Temps /2");

  final String nom;

  const Specificite({required this.nom});

}
