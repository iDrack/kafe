import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                      Navigator.of(context).pushNamed('/home');
                    }
                  });
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(res)));
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
      leadingWidget: SizedBox(),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment(0, -0.65),
            child: Text(
              "Bienvenue dans le Kafé",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child:
                (isLoading.value)
                    ? CircularProgressIndicator()
                    : AuthForm(
                      submitLoginFn: login,
                      submitRegisterFn: signin,
                    ),
          ),
        ],
      ),
    );
  }
}
