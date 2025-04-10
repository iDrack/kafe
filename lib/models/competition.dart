import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe/models/assemblage.dart';
import 'package:kafe/models/enums/epreuve.dart';

class Competition {
  late final String id;
  late String? gagnantId = "";
  late String? secondGagnantId = "";
  late List<Assemblage> assemblageParticipants;
  late final Epreuve premiereEpreuve;
  late final Epreuve secondeEpreuve;
  late DateTime dateEpreuve;

  Competition({
    required this.assemblageParticipants,
    required this.dateEpreuve,
  }) {
    List<Epreuve> epreuvesDisponible = List.from(Epreuve.values);
    int choice = Random().nextInt(3);
    premiereEpreuve = epreuvesDisponible[choice];
    epreuvesDisponible.removeAt(choice);
    choice = Random().nextInt(2);
    secondeEpreuve = epreuvesDisponible[choice];
  }

  Competition.all({
    required this.id,
    required this.assemblageParticipants,
    required this.gagnantId,
    required this.secondGagnantId,
    required this.premiereEpreuve,
    required this.secondeEpreuve,
    required this.dateEpreuve,
  });

  void findWinner() {
    Assemblage? winner1;
    Assemblage? winner2;
    num scoreWinner1 = 0;
    num scoreWinner2 = 0;
    assemblageParticipants.forEach((assemblage) {
      num currentScore1 = premiereEpreuve.doEpreuve(
        assemblage.gato["Gout"]!,
        assemblage.gato["Teneur"]!,
        assemblage.gato["Odorat"]!,
        assemblage.gato["Amertume"]!,
      );
      num currentScore2 = secondeEpreuve.doEpreuve(
        assemblage.gato["Gout"]!,
        assemblage.gato["Teneur"]!,
        assemblage.gato["Odorat"]!,
        assemblage.gato["Amertume"]!,
      );
      if (currentScore1 > scoreWinner1) {
        scoreWinner1 = currentScore1;
        winner1 = assemblage;
      }
      if (currentScore2 > scoreWinner2) {
        scoreWinner2 = currentScore2;
        winner2 = assemblage;
      }
    });

    gagnantId = winner1?.userId;
    secondGagnantId = winner2?.userId;
  }

  Map<String, dynamic> toDocument() {
    return {
      'gagnantId': gagnantId ?? "",
      'secondGagnantId': secondGagnantId ?? "",
      'assemblageParticipants':
          assemblageParticipants.map((a) => a.toDocument()).toList(),
      'premiereEpreuve': premiereEpreuve.nom,
      'secondeEpreuve': secondeEpreuve.nom,
      'dateEpreuve': dateEpreuve.toIso8601String(),
    };
  }

  factory Competition.fromSnapshot(QueryDocumentSnapshot snapshot, String id) {
    return Competition.all(
      id: id,
      gagnantId: snapshot['gagnantId'] ?? "",
      secondGagnantId: snapshot['secondGagnantId'] ?? "",
      assemblageParticipants:
          (snapshot['assemblageParticipants'] as List<dynamic>)
              .map((a) {
                print(a['id']);
                return Assemblage.fromMap(a);
              })
              .toList(),
      premiereEpreuve: Epreuve.values.firstWhere(
        (e) => e.nom == snapshot['premiereEpreuve'],
      ),
      secondeEpreuve: Epreuve.values.firstWhere(
        (e) => e.nom == snapshot['secondeEpreuve'],
      ),
      dateEpreuve: DateTime.parse(snapshot['dateEpreuve']),
    );
  }

factory Competition.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot, String id) {
  return Competition.all(
    id: id,
    gagnantId: snapshot['gagnantId'],
    secondGagnantId: snapshot['secondGagnantId'],
    assemblageParticipants: (snapshot['assemblageParticipants'] as List<dynamic>)
        .map((a) => Assemblage.fromMap(a as Map<String, dynamic>))
        .toList(),
    premiereEpreuve: Epreuve.values.firstWhere(
      (e) => e.nom == snapshot['premiereEpreuve'],
    ),
    secondeEpreuve: Epreuve.values.firstWhere(
      (e) => e.nom == snapshot['secondeEpreuve'],
    ),
    dateEpreuve: DateTime.parse(snapshot['dateEpreuve']),
  );
}
}
