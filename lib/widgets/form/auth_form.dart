import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'submit_button.dart';

class AuthForm extends HookConsumerWidget {
  final void Function(String email, String password) submitLoginFn;
  final void Function(String email, String password, String username)
  submitRegisterFn;

  AuthForm({
    required this.submitLoginFn,
    required this.submitRegisterFn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final secondPasswordController = useTextEditingController();
    final usernameController = useTextEditingController();
    final isLogin = useState(true);

    void trySubmit() {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (!isLogin.value &&
          (passwordController.text != secondPasswordController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Les mots de passes ne correspondent pas.'),
          ),
        );
        return;
      }

      if (isValid) {
        _formKey.currentState!.save();
        isLogin.value
            ? submitLoginFn(
              emailController.text.trim(),
              passwordController.text.trim(),
            )
            : submitRegisterFn(
              emailController.text.trim(),
              passwordController.text.trim(),
              usernameController.text.trim(),
            );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Informations erronées.')));
      }
    }

    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!isLogin.value)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Adresse email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (!isLogin.value)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: TextFormField(
                  controller: secondPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Retaper votre mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Column(
              children: [
                SubmitButton(
                  text: isLogin.value ? 'Se connecter' : 'S\'inscrire',
                  onPressed: trySubmit,
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                isLogin.value = !isLogin.value;
              },
              child: Text(
                isLogin.value
                    ? 'Créer un nouveau compte'
                    : 'J\'ai déjà un compte',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
