import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import 'firebase_auth_provider.dart';

final fireStoreProvider =
StateNotifierProvider<FirestoreNotifier, FirebaseFirestore>(
        (ref) => FirestoreNotifier(ref: ref));

class FirestoreNotifier extends StateNotifier<FirebaseFirestore> {

  Ref ref;

  FirestoreNotifier({required this.ref}) : super(FirebaseFirestore.instance);

  //Gestion utilisateur
  Future<void> createNewUser(AppUser user) async {
    try {
      await state.collection('users').doc(user.uuid).set(user.toDocument());
    } catch (e) {
      print(e);
    }
  }

  Future<AppUser> retrieveUserInfos(String uuid) async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uuid).get();
      return AppUser.fromSnapshot(snapshot.data(), uuid);
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateUserInfos(AppUser user) async {
    try {
      await state.collection('users').doc(user.uuid).update(user.toDocument());
      ref.watch(userProvider.notifier).state = AppUser(
        uuid: user.uuid,
        email: user.email,
        name: user.name,
        deevee: user.deevee,
        goldenSeed: user.goldenSeed,
        quantiteKafe: user.quantiteKafe,
        quantiteGraine: user.quantiteGraine,
      );
    } catch (e) {
      print(e);
    }
  }

}
