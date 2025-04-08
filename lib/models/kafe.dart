enum Kafe {
  Rubisca(
    nom: "☕ Rubisca",
    tempsDePousse: 60,
    prix: 2,
    tailleProductionInitial: 0.632,
    gout: 15,
    amertume: 54,
    teneur: 35,
    odorat: 19,
  ),
  Arbrista(
    nom: "☕ Arbrista",
    tempsDePousse: 4*60,
    prix: 6,
    tailleProductionInitial: 0.274,
    gout: 87,
    amertume: 4,
    teneur: 35,
    odorat: 59,
  ),
  Roupetta(
    nom: "☕ Roupetta",
    tempsDePousse: 2*60,
    prix: 3,
    tailleProductionInitial: 0.461,
    gout: 35,
    amertume: 41,
    teneur: 75,
    odorat: 67,
  ),
  Tourista(
    nom: "☕ Tourista",
    tempsDePousse: 60,
    prix: 1,
    tailleProductionInitial: 0.961,
    gout: 3,
    amertume: 91,
    teneur: 74,
    odorat: 6,
  ),
  Goldoriat(
    nom: "☕ Goldoriat",
    tempsDePousse: 3*60,
    prix: 2,
    tailleProductionInitial: 0.473,
    gout: 39,
    amertume: 9,
    teneur: 7,
    odorat: 87,
  );

  final String nom;
  final int tempsDePousse;
  final int prix;
  final num tailleProductionInitial;
  final int gout;
  final int amertume;
  final int teneur;
  final int odorat;

  const Kafe({
    required this.nom,
    required this.tempsDePousse,
    required this.prix,
    required this.tailleProductionInitial,
    required this.gout,
    required this.amertume,
    required this.teneur,
    required this.odorat,
  });


}
