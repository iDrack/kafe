import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe/models/assemblage.dart';

import '../models/app_user.dart';
import '../models/competition.dart';
import '../models/enums/kafe.dart';

final assemblageStreamProvider =
    StreamNotifierProvider<AssemblageStreamNotifier, List<Assemblage>>(
      AssemblageStreamNotifier.new,
    );

class AssemblageStreamNotifier extends StreamNotifier<List<Assemblage>> {
  @override
  Stream<List<Assemblage>> build() {
    return FirebaseFirestore.instance
        .collection('assemblages')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Assemblage.fromSnapshot(doc, doc.id))
                  .toList(),
        );
  }

Future<void> add(Assemblage assemblage, AppUser user) async {
  final updatedQuantiteKafe = Map<Kafe, num>.from(user.quantiteKafe);
  assemblage.quantiteKafe.entries.forEach((ingredient) {
    if (updatedQuantiteKafe.containsKey(ingredient.key)) {
      updatedQuantiteKafe[ingredient.key] =
          (updatedQuantiteKafe[ingredient.key]! - ingredient.value).clamp(0, double.infinity);
    }
  });

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uuid)
      .update({'quantiteKafe': updatedQuantiteKafe.map((key, value) => MapEntry(key.nom, value))});

  await FirebaseFirestore.instance
      .collection('assemblages')
      .add(assemblage.toDocument());
}

Future<void> updateAssemblage(Assemblage assemblage) async {
  await FirebaseFirestore.instance
      .collection('assemblages')
      .doc(assemblage.id)
      .update(assemblage.toDocument());

  if (!assemblage.inscrit) {
    QuerySnapshot competitionSnapshot =
        await FirebaseFirestore.instance.collection('competitions').get();

    for (var doc in competitionSnapshot.docs) {
      Competition competition = Competition.fromSnapshot(doc, doc.id);

      int initialCount = competition.assemblageParticipants.length;
      competition.assemblageParticipants.removeWhere(
        (a) => a.id == assemblage.id,
      );

      if (competition.assemblageParticipants.length < initialCount) {
        await FirebaseFirestore.instance
            .collection('competitions')
            .doc(competition.id)
            .update(competition.toDocument());
      }
    }
  }
}

  Stream<List<Assemblage>> fetchAssemblages(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;
    snapshots =
        FirebaseFirestore.instance
            .collection('assemblages')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: false)
            .snapshots();

    return snapshots.map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => Assemblage.fromSnapshot(doc, doc.id))
              .toList(),
    );
  }

  Stream<List<Assemblage>> fetchAssemblageInscrit(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;
    snapshots =
        FirebaseFirestore.instance
            .collection('assemblages')
            .where('userId', isEqualTo: userId)
            .where('inscrit', isEqualTo: true)
            .orderBy('createdAt', descending: false)
            .snapshots();

    return snapshots.map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => Assemblage.fromSnapshot(doc, doc.id))
              .toList(),
    );
  }

  Stream<List<Assemblage>> fetchAllAssemblageInscrit() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;
    snapshots =
        FirebaseFirestore.instance
            .collection('assemblages')
            .where('inscrit', isEqualTo: true)
            .orderBy('createdAt', descending: false)
            .snapshots();

    return snapshots.map(
          (snapshot) =>
          snapshot.docs
              .map((doc) => Assemblage.fromSnapshot(doc, doc.id))
              .toList(),
    );
  }

  Future<void> setAssemblageInscrit(Assemblage assemblage) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('assemblages')
            .where('userId', isEqualTo: assemblage.userId)
            .where('inscrit', isEqualTo: true)
            .orderBy('createdAt', descending: false)
            .get();

    if (snapshot.docs.isNotEmpty) {
      for (final doc in snapshot.docs) {
        final oldInscrit = Assemblage.fromSnapshot(doc, doc.id);

        oldInscrit.inscrit = false;
        await updateAssemblage(oldInscrit);
      }
    }

    assemblage.inscrit = true;
    await updateAssemblage(assemblage);

    final competitionSnapshot =
        await FirebaseFirestore.instance.collection('competitions').get();

    for (var doc in competitionSnapshot.docs) {
      final competition = Competition.fromSnapshot(doc, doc.id);

      if (!competition.assemblageParticipants.any((a) => a.id == assemblage.id)) {
        competition.assemblageParticipants.add(assemblage);
        await FirebaseFirestore.instance
            .collection('competitions')
            .doc(competition.id)
            .update(competition.toDocument());
      }
    }
  }

  Future<void> deleteAssemblage(Assemblage assemblage) async {
    final competitionSnapshot =
        await FirebaseFirestore.instance.collection('competitions').get();

    for (var doc in competitionSnapshot.docs) {
      final competition = Competition.fromSnapshot(doc, doc.id);

      competition.assemblageParticipants.removeWhere((a) => a.id == assemblage.id);

      await FirebaseFirestore.instance
          .collection('competitions')
          .doc(competition.id)
          .update(competition.toDocument());
    }

    await FirebaseFirestore.instance
        .collection('assemblages')
        .doc(assemblage.id)
        .delete();
  }
}
