import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_user.dart';
import 'fire_store_provider.dart';

final firebaseUser = StateProvider<User?>((ref) => null);

final userProvider = StateProvider<AppUser?>((ref) => null);

final firebaseAuthProvider =
    StateNotifierProvider<FirebaseAuthProvider, FirebaseAuth?>(
        (ref) => FirebaseAuthProvider(ref));

class FirebaseAuthProvider extends StateNotifier<FirebaseAuth?> {

  Ref ref;

  FirebaseAuthProvider(this.ref) : super(null);

  Future<void> initialize() async {
    state = FirebaseAuth.instance;
    if (state != null) {
      state!.authStateChanges().listen(
        (User? user) {
          if (user == null) {
            ref.read(firebaseUser.notifier).state = null;
          } else {
            ref.read(firebaseUser.notifier).state = user;
            ref
                .read(fireStoreProvider.notifier)
                .retrieveUserInfos(user.uid)
                .then((user) {
              ref.watch(userProvider.notifier).state = user;
            });
          }
        },
      );
    }
  }

  Future<bool> logIn(String email, String password) async {
    if (state == null) {
      return false;
    }
      try {
        await state!
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          if (value.user != null) {
            ref
                .read(fireStoreProvider.notifier)
                .retrieveUserInfos(value.user!.uid)
                .then((user) {
                  ref.watch(userProvider.notifier).state = user;
                });
          }
        });
        return true;
      } on FirebaseAuthException catch (e) {
        return false;
      }
  }


  Future<String?> createUserInFirebase(String name, String email, String password) async {

    final usernameExists = await this.usernameExists(name);
    if (usernameExists) {
      return "Le nom d'utilisateur existe déjà";
    }

    await signIn(email, password)
      .then((value) {
        if (value != null && value.user != null) {
          final user = AppUser(uuid: value.user!.uid, name: name, email: email, deevee: 10, goldenSeed: 0);
          ref.read(fireStoreProvider.notifier).createNewUser(user);
        }
      }, onError: (error) => 'Failed to signin.');

    return null;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await state!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print("___________Error : ");
      print(e);
      return null;
    }
  }

  Future<bool> usernameExists(String username) async {
    final result =  await FirebaseFirestore.instance
                                                      .collection('users')
                                                      .where('username', isEqualTo: username)
                                                      .get();
      return result.docs.isNotEmpty;
  }
  

  Future<void> logout() async {
    ref.watch(userProvider.notifier).state = null;
    ref.watch(firebaseUser.notifier).state = null;

    if (state != null) {
      ref.read(userProvider.notifier).state = null;
      ref.watch(firebaseUser.notifier).state = null;

      await state!.signOut();
    }
  }
}
