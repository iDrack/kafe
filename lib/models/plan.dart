import 'package:kafe/models/pousse.dart';

class Plan {
    Pousse? pousse;

    Plan();

    Plan.all({required this.pousse});

    Map<String, dynamic> toMap() {
      return {
        'pousse': pousse?.toMap(), // Vérification si pousse est null
      };
    }

    factory Plan.fromMap(Map<String, dynamic> map) {
      return Plan.all(
        pousse: map['pousse'] != null
            ? Pousse.fromMap(map['pousse'] as Map<String, dynamic>)
            : null, // Vérification si pousse est null
      );
    }
  }