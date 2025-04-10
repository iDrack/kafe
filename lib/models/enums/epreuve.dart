import 'dart:math';

enum Epreuve {
  Tasse(nom: "Tasse", deevee: 2, graine: 2),
  Kafetiere(nom: "Kafetière", deevee: 3, graine: 1),
  Degustation(nom: "Dégustation", deevee: 5, graine: 3);

  final String nom;
  final int deevee;
  final int graine;

  const Epreuve({required this.nom, required this.deevee, required this.graine});

  num doEpreuve(num gout, num teneur, num odorat, num amertume) {
    switch (this) {
      case Epreuve.Tasse:
        return 0.8 * gout +
            teneur +
            0.3 * odorat +
            0.1 * amertume +
            Random().nextDouble();
      case Epreuve.Kafetiere:
        return 0.1 * gout +
            0.5 * teneur +
            0.8 * odorat +
            0.1 * amertume +
            Random().nextDouble();
      case Epreuve.Degustation:
        return 0.4 * teneur +
            0.8 * gout +
            0.4 * odorat +
            0.4 * amertume +
            Random().nextDouble();
    }
  }
}
