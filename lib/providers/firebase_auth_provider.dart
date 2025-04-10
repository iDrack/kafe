import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafe/models/enums/kafe.dart';
import '../models/app_user.dart';
import 'fire_store_provider.dart';

final firebaseUser = StateProvider<User?>((ref) => null);

final userProvider = StateProvider<AppUser?>((ref) => null);

final userStreamProvider = StreamProvider<AppUser?>((ref) {
  final currentUser = ref.watch(firebaseUser);
  if (currentUser == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.exists) {
          return AppUser.fromSnapshot(snapshot.data(), snapshot.id);
        }
        return null;
      });
});

final firebaseAuthProvider =
    StateNotifierProvider<FirebaseAuthProvider, FirebaseAuth?>(
      (ref) => FirebaseAuthProvider(ref),
    );

class FirebaseAuthProvider extends StateNotifier<FirebaseAuth?> {
  Ref ref;

  FirebaseAuthProvider(this.ref) : super(null);

  Future<void> initialize() async {
    state = FirebaseAuth.instance;
    if (state != null) {
      state!.authStateChanges().listen((User? user) async {
        if (user == null) {
          ref.read(firebaseUser.notifier).state = null;
          ref.read(userProvider.notifier).state = null;
        } else {
          ref.read(firebaseUser.notifier).state = user;
          final appUser = await ref.read(fireStoreProvider.notifier).retrieveUserInfos(user.uid);
          ref.read(userProvider.notifier).state = appUser;
        }
      });
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

  Future<String?> createUserInFirebase(
    String name,
    String email,
    String password,
  ) async {
    final usernameExists = await this.usernameExists(name);
    if (usernameExists) {
      return "Le nom d'utilisateur existe déjà";
    }

    await signIn(email, password).then((value) {
      if (value != null && value.user != null) {
        final user = AppUser(
          uuid: value.user!.uid,
          name: name,
          email: email,
          deevee: 15,
          goldenSeed: 0,
          quantiteKafe: {
            Kafe.Rubisca: 0.0,
            Kafe.Goldoriat: 0.0,
            Kafe.Arbrista: 0.0,
            Kafe.Roupetta: 0.0,
            Kafe.Tourista: 0.0,
          },
          quantiteGraine: {
            Kafe.Rubisca: 0.0,
            Kafe.Goldoriat: 0.0,
            Kafe.Arbrista: 0.0,
            Kafe.Roupetta: 0.0,
            Kafe.Tourista: 0.0,
          },
        );
        print(user.toDocument());
        ref.read(fireStoreProvider.notifier).createNewUser(user);
      }
    }, onError: (error) => 'Echec de la création de compte.');

    return null;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await state!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> usernameExists(String username) async {
    final result =
        await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .get();
    return result.docs.isNotEmpty;
  }

  Future<int> getDeevee() async {
    final user = ref.watch(userProvider.notifier).state;
    return user?.deevee ?? 0;
  }

  Future<void> updateDeevee(int amount) async {
    final user = ref.watch(userProvider.notifier).state;
    if (user == null) {
      throw Exception("Aucun utilisateur connecté.");
    }

    if (amount < 0 && user.deevee < amount) {
      throw Exception("Fonds insuffisants.");
    }

    user.deevee += amount;

    await FirebaseFirestore.instance.collection('users').doc(user.uuid).update({
      'deevee': user.deevee,
    });
    ref.read(userProvider.notifier).state = user;
  }

  Future<void> updateGoldenSeed(int amount) async {
    final user = ref.watch(userProvider.notifier).state;
    if (user == null) {
      throw Exception("Aucun utilisateur connecté.");
    }

    if (amount < 0 && user.goldenSeed < amount) {
      throw Exception("Fonds insuffisants.");
    }

    user.goldenSeed += amount;

    await FirebaseFirestore.instance.collection('users').doc(user.uuid).update({
      'goldenSeed': user.goldenSeed,
    });
    ref.read(userProvider.notifier).state = user;
  }

  Future<void> updateQuantiteGraine(Kafe kafe, num amount) async {
    final user = ref.watch(userProvider.notifier).state;
    if (user == null) {
      throw Exception("Aucun utilisateur connecté.");
    }

    if (amount < 0) {
      if ((user.quantiteGraine[kafe] ?? 0) + amount < 0) {
        throw Exception("Quantité de graines de ${kafe.nom} insuffisantes.");
      }
    }

    user.quantiteGraine[kafe] = (user.quantiteGraine[kafe] ?? 0) + amount;
    await FirebaseFirestore.instance.collection('users').doc(user.uuid).update({
      'quantiteGraine': user.quantiteGraine.map((key, value) => MapEntry(key.nom, value)),
    });
    ref.read(userProvider.notifier).state = user;
  }

  Future<void> updateSechage(Kafe kafe, num amount) async {
    updateQuantiteKafe(kafe, -amount);
    updateQuantiteGraine(kafe, amount * 0.952);

  }

  Future<void> updateQuantiteKafe(Kafe kafe, num amount) async {
    final user = ref.watch(userProvider.notifier).state;
    if (user == null) {
      throw Exception("Aucun utilisateur connecté.");
    }

    if (amount < 0) {
      if ((user.quantiteKafe[kafe] ?? 0) + amount < 0) {
        throw Exception("Quantité de fruit de ${kafe.nom} insuffisants.");
      }
    }

    user.quantiteKafe[kafe] = (user.quantiteKafe[kafe] ?? 0) + amount;
    await FirebaseFirestore.instance.collection('users').doc(user.uuid).update({
      'quantiteKafe': user.quantiteKafe.map((key, value) => MapEntry(key.nom, value)),
    });
    ref.read(userProvider.notifier).state = user;
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
