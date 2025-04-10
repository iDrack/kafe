import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe/models/assemblage.dart';
import 'package:kafe/providers/firebase_auth_provider.dart';

import '../models/competition.dart';

final competitionStreamProvider =
    StreamNotifierProvider<CompetitionStreamNotifier, List<Competition>>(
      CompetitionStreamNotifier.new,
    );

class CompetitionStreamNotifier extends StreamNotifier<List<Competition>> {
  @override
  Stream<List<Competition>> build() {
    return FirebaseFirestore.instance
        .collection('competitions')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Competition.fromSnapshot(doc, doc.id))
                  .toList(),
        );
  }

  Future<String> add(Competition competition) async {
    final docRef = await FirebaseFirestore.instance
        .collection('competitions')
        .add(competition.toDocument());
    return docRef.id;
  }

  Stream<List<Competition>> fetchCompetitions() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;
    snapshots =
        FirebaseFirestore.instance
            .collection('competitions')
            .where('assemblageParticipants', isNotEqualTo: [])
            .snapshots();

    return snapshots.map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => Competition.fromSnapshot(doc, doc.id))
              .toList(),
    );
  }

  Stream<List<Competition>> fetchCompetitionsIfUserWon(
    String userId, ) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;
    snapshots =
        FirebaseFirestore.instance
            .collection('competitions')
            .where('assemblageParticipants', isNotEqualTo: [])
            .where('gagnantId', isEqualTo: userId)
            .where('secondGagnantId', isEqualTo: userId)
            .snapshots();


    return snapshots.map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => Competition.fromSnapshot(doc, doc.id))
              .toList(),
    );
  }

  Future<void> updateCompetition(Competition competition) async {
    await FirebaseFirestore.instance
        .collection('competitions')
        .doc(competition.id)
        .update(competition.toDocument());
  }

  Future<void> FindWinners(Competition competition) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('competitions')
        .doc(competition.id)
        .get();

    if (snapshot.exists) {
      final updatedCompetition = Competition.fromDocument(
        snapshot,
        competition.id,
      );

      if ((updatedCompetition.gagnantId == null || updatedCompetition.gagnantId!.isEmpty) &&
          (updatedCompetition.secondGagnantId == null || updatedCompetition.secondGagnantId!.isEmpty)) {
        updatedCompetition.findWinner();
        await updateCompetition(updatedCompetition);
      }
    }
  }

  Future<Map<String,int>> claimReward(Competition competition, String userId) async {
    Map<String, int> rewards = {"deevee": 0, "goldenSeed": 0};
    if (competition.gagnantId == userId) {
      competition.gagnantId = "";
      rewards["deevee"] = (rewards["deevee"] ?? 0) + competition.premiereEpreuve.deevee;
      rewards["goldenSeed"] = (rewards["goldenSeed"] ?? 0) + competition.premiereEpreuve.graine;
    }

    if (competition.secondGagnantId == userId) {
      competition.secondGagnantId = "";
      rewards["deevee"] = (rewards["deevee"] ?? 0) + competition.secondeEpreuve.deevee;
      rewards["goldenSeed"] = (rewards["goldenSeed"] ?? 0) + competition.secondeEpreuve.graine;
    }

    if(rewards["deevee"] != 0 && rewards["goldenSeed"] != 0) {
      ref
          .watch(firebaseAuthProvider.notifier)
          .updateDeevee(competition.secondeEpreuve.deevee);
      ref
          .watch(firebaseAuthProvider.notifier)
          .updateGoldenSeed(competition.secondeEpreuve.graine);
    }
    if (competition.gagnantId == "" && competition.secondGagnantId == "") {
      FirebaseFirestore.instance
          .collection('competitions')
          .doc(competition.id)
          .delete();
    } else {
      updateCompetition(competition);
    }
    return rewards;
  }
}
