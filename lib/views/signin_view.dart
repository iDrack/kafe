import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/models/champ.dart';
import 'package:kafe/providers/champ_stream_provider.dart';

import '../models/app_user.dart';
import '../providers/firebase_auth_provider.dart';
import '../widgets/form/auth_form.dart';
import '../widgets/main_scaffold.dart';

class SigninView extends HookConsumerWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);

    void signin(String email, String password, String username) {
      isLoading.value = true;

      ref
          .watch(firebaseAuthProvider.notifier)
          .createUserInFirebase(username, email, password)
          .then((res) {
            if (res == null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Compte créé.")));
              ref
                  .watch(firebaseAuthProvider.notifier)
                  .logIn(email, password)
                  .then((res) {
                    if (res) {
                      final AppUser? currentuser = ref.watch(userProvider);
                      ref.watch(champStreamProvider.notifier).add(Champ(userId: currentuser!.uuid));
                      Navigator.of(context).pushNamed('/home');
                    }
                  });
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(res)));
              isLoading.value = false;
            }
          });

      isLoading.value = false;
    }

    void login(String email, String password) {
      isLoading.value = true;

      ref.watch(firebaseAuthProvider.notifier).logIn(email, password).then((
        res,
      ) {
        if (res) {
          Navigator.of(context).pushNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Les informations sont incorrectes.")),
          );
          isLoading.value = false;
        }
      });

      isLoading.value = false;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ref.watch(firebaseUser) != null) {
          Navigator.of(context).pushNamed('/home');
        }
      });
      return null;
    }, []);

    return MainScaffold(
      title: "",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bienvenue dans le Kafé",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 24,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child: AuthForm(
                      submitLoginFn: login,
                      submitRegisterFn: signin,
                    ),
          ),
        ],
      ),
    );
  }
}
