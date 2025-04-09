import 'enums/kafe.dart';

class AppUser {
  final String uuid;
  final String email;
  String name;
  int deevee = 0;
  int goldenSeed = 0;
  final Map<Kafe, num> quantiteKafe;
  final Map<Kafe, num> quantiteGraine;

  AppUser({
    required this.uuid,
    required this.name,
    required this.email,
    required this.deevee,
    required this.goldenSeed,
    this.quantiteKafe = const {},
    this.quantiteGraine = const {},
  });

  Map<String, dynamic> toDocument() {
    return {
      'name': this.name,
      'email': this.email,
      'uuid': this.uuid,
      'deevee': this.deevee,
      'goldenSeed': this.goldenSeed,
      'quantiteKafe': this.quantiteKafe.map(
        (key, value) => MapEntry(key.nom, value),
      ),
      'quantiteGraine': this.quantiteGraine.map(
            (key, value) => MapEntry(key.nom, value),
      ),
    };
  }

  factory AppUser.fromSnapshot(Map<String, dynamic>? snapshot, String uuid) {
    if (snapshot == null) {
      throw Exception("Impossible de récupérer la snapshot");
    }
    return AppUser(
        name: snapshot["name"] ?? "Nom inconnu",
        email: snapshot["email"] ?? "Email inconnu",
        uuid: uuid,
        deevee: snapshot["deevee"] ?? 0,
        goldenSeed: snapshot["goldenSeed"] ?? 0,
      quantiteKafe: (snapshot["quantiteKafe"] as Map?)?.map<Kafe, num>((key, value) {
        return MapEntry(Kafe.values.firstWhere((e) => e.nom == key, orElse: () => Kafe.Rubisca), value as num);
      }) ?? {},
      quantiteGraine: (snapshot["quantiteGraine"] as Map?)?.map<Kafe, num>((key, value) {
        return MapEntry(Kafe.values.firstWhere((e) => e.nom == key, orElse: () => Kafe.Rubisca), value as num);
      }) ?? {},
    );
  }
}
