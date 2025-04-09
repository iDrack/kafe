import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe/models/assemblage.dart';

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

  Future<void> add(Assemblage assemblage) async {
    FirebaseFirestore.instance
        .collection('assemblages')
        .add(assemblage.toDocument());
  }

  Future<void> updateAssemblage(Assemblage assemblage) async {
    FirebaseFirestore.instance
        .collection('assemblages')
        .doc(assemblage.id)
        .update(assemblage.toDocument());
  }

  Stream<List<Assemblage>> fetchAssemblages(String userId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;snapshots =
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

  Future<void> deleteAssemblage(Assemblage assemblage) async {
    await FirebaseFirestore.instance
        .collection('assemblages')
        .doc(assemblage.id)
        .delete();
  }
}
