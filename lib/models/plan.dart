import 'enums/kafe.dart';

class Plan {
  Kafe? kafe;
  DateTime? datePlantation;

  Plan();

  Plan.all({required this.kafe, required this.datePlantation});

  Map<String, dynamic> toMap() {
    return {
      'kafe': kafe?.nom,
      'datePlantation': datePlantation?.toIso8601String(),
    };
  }

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan.all(
      kafe:
          map['kafe'] != null
              ? Kafe.values.firstWhere((x) => x.nom == map['kafe'])
              : null, // Vérification si pousse est null
      datePlantation:
          map['datePlantation'] != null
              ? DateTime.parse(map['datePlantation'])
              : null,
    );
  }
}
