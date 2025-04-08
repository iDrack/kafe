import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kafe/models/plan.dart';
import 'package:kafe/models/specificite.dart';

class Champ {
  final String userId;
  late final String id;
  late final Specificite specificite;
  late final List<Plan> plans;
  final DateTime createdAt;

  Champ({required this.userId}) : createdAt = DateTime.now() {
    int choice = Random().nextInt(3);
    specificite = Specificite.values[choice];
    plans = [Plan(), Plan(), Plan(), Plan()];
  }

  Champ.all({
    required this.userId,
    required this.specificite,
    required this.plans,
    required this.id,
    required this.createdAt,
  });

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'specificite': specificite.nom,
      'plans': plans.map((plan) => plan.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      //'plans': plans.map((plan) => Plan()).toList(),
    };
  }

  factory Champ.fromSnapshot(QueryDocumentSnapshot snapshot, String id) {
    return Champ.all(
      userId: snapshot["userId"],
      specificite: Specificite.values.firstWhere(
        (x) => x.nom == snapshot["specificite"],
      ),
      plans: (snapshot['plans'] as List<dynamic>)
          .map((plan) => Plan.fromMap(plan as Map<String, dynamic>))
          .toList(),
      id: id,
      createdAt: DateTime.parse(snapshot['createdAt'])
    );
  }
}
