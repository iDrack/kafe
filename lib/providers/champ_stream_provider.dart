import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe/models/champ.dart';

final champStreamProvider =
    StreamNotifierProvider<ChampStreamNotifier, List<Champ>>(
      ChampStreamNotifier.new,
    );

class ChampStreamNotifier extends StreamNotifier<List<Champ>> {
  @override
  Stream<List<Champ>> build() {
    return FirebaseFirestore.instance
        .collection('champs')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Champ.fromSnapshot(doc, doc.id))
                  .toList(),
        );
  }

  Future<void> add(Champ champ) async {
    FirebaseFirestore.instance.collection('champs').add(champ.toDocument());
  }

  Future<void> updateChamp(Champ champ, String id) async {
    FirebaseFirestore.instance
        .collection('champs')
        .doc(id)
        .update(champ.toDocument());
  }

  Stream<List<Champ>> fetchChamps(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;
    snapshots =
        FirebaseFirestore.instance
            .collection('champs')
            .where('userId', isEqualTo: userId)
            .snapshots();

    return snapshots.map(
      (snapshot) =>
          snapshot.docs.map((doc) => Champ.fromSnapshot(doc, doc.id)).toList(),
    );
  }
}
