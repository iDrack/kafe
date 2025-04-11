import 'package:cloud_firestore/cloud_firestore.dart';

import 'enums/kafe.dart';

class Assemblage {
  final String userId;
  late final String id;
  late final Map<Kafe, num> quantiteKafe;
  late final Map<String, num> gato;
  late num poid;
  final DateTime createdAt;
  late bool inscrit;

  Assemblage({required this.userId, required this.quantiteKafe})
    : createdAt = DateTime.now() {
    id = "";
    poid = 0.0;
    inscrit = false;
    gato = {"Gout": 0.0, "Amertume": 0.0, "Teneur": 0.0, "Odorat": 0.0};

    quantiteKafe.values.forEach((x) => poid += x);

    quantiteKafe.entries.forEach((item) {
      gato["Gout"] =
          (gato["Gout"] ?? 0) + (item.key.gout * ((item.value / poid)));
      gato["Amertume"] =
          (gato["Amertume"] ?? 0) + (item.key.amertume * ((item.value / poid)));
      gato["Teneur"] =
          (gato["Teneur"] ?? 0) + (item.key.teneur * ((item.value / poid)));
      gato["Odorat"] =
          (gato["Odorat"] ?? 0) + (item.key.odorat * ((item.value / poid)));
    });
  }

  Assemblage.all({
    required this.userId,
    required this.id,
    required this.quantiteKafe,
    required this.gato,
    required this.poid,
    required this.createdAt,
    required this.inscrit,
  });

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'id': id,
      'quantiteKafe': this.quantiteKafe.map(
        (key, value) => MapEntry(key.nom, value),
      ),
      'gato': this.gato.map((key, value) => MapEntry(key, value)),
      'poid': this.poid,
      'createdAt': this.createdAt.toIso8601String(),
      'inscrit': this.inscrit,
    };
  }

  factory Assemblage.fromSnapshot(QueryDocumentSnapshot snapshot, String id) {
    return Assemblage.all(
      userId: snapshot['userId'],
      id: id,
      quantiteKafe:
          (snapshot["quantiteKafe"] as Map?)?.map<Kafe, num>((key, value) {
            return MapEntry(
              Kafe.values.firstWhere(
                (e) => e.nom == key,
                orElse: () => Kafe.Rubisca,
              ),
              value as num,
            );
          }) ??
          {},
      gato:
          (snapshot["gato"] as Map?)?.map<String, num>((key, value) {
            return MapEntry(key, value as num);
          }) ??
          {},
      poid: snapshot['poid'],
      createdAt: DateTime.parse(snapshot['createdAt']),
      inscrit: snapshot['inscrit'],
    );
  }

  factory Assemblage.fromMap(Map<String, dynamic> map) {
    return Assemblage.all(
      userId: map['userId'] as String,
      id: map['id'] as String,
      quantiteKafe: (map['quantiteKafe'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          Kafe.values.firstWhere(
            (e) => e.nom == key,
            orElse: () => Kafe.Rubisca,
          ),
          value as num,
        ),
      ),
      gato: (map['gato'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key as String, value as num),
      ),
      poid: map['poid'] as num,
      createdAt: DateTime.parse(map['createdAt'] as String),
      inscrit: map['inscrit'] as bool,
    );
  }
}
