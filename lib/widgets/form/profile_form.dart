import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/widgets/form/submit_button.dart';

import '../../providers/firebase_auth_provider.dart';

class ProfileForm extends HookConsumerWidget {
  final void Function(String? newUsername, String? newPassword) onSubmit;

  const ProfileForm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final secondPasswordController = useTextEditingController();

    // Initialisation du nom d'utilisateur à partir de l'état utilisateur
    useEffect(() {
      final user = ref.read(userProvider.notifier).state;
      if (user != null) {
        usernameController.text = user.name;
      }
      return null; // Pas de cleanup nécessaire
    }, []);

    void _updateProfile() {
      if (passwordController.text != secondPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Les mots de passes ne correspondent pas.'),
          ),
        );
        return;
      }
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState!.save();

        final String? newUsername =
            usernameController.text.trim().isNotEmpty
                ? usernameController.text.trim()
                : null;
        final String? newPassword =
            passwordController.text.trim().isNotEmpty
                ? passwordController.text.trim()
                : null;

        onSubmit(newUsername, newPassword);
      }
    }

    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: secondPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Retaper le mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SubmitButton(
              text: 'Mettre à jour le profil',
              onPressed: _updateProfile,
            ),
          ],
        ),
      ),
    );
  }
}
