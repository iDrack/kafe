import 'package:kafe/models/plan.dart';

import 'kafe.dart';

class Pousse {
  final Plan plan;
  final Kafe kafe;
  late final DateTime datePlantation;
  final DateTime dateFinPrevu;

  Pousse({required this.plan, required this.kafe, required this.dateFinPrevu}) {
    datePlantation = DateTime.now();
  }
  
  
  Map<String, dynamic> toMap() {
    return {
      'plan': plan.toMap(),
      'kafe': kafe.nom,
      'datePlantation': datePlantation.toIso8601String(),
      'dateFinPrevu': dateFinPrevu.toIso8601String(),
    };
  }

  factory Pousse.fromMap(Map<String, dynamic> map) {
    return Pousse(
      plan: Plan.fromMap(map['plan']),
      kafe: Kafe.values.firstWhere((x) => x.nom == map['kafe']),
      dateFinPrevu: DateTime.parse(map['dateFinPrevu']),
    )..datePlantation = DateTime.parse(map['datePlantation']);
  }
}
