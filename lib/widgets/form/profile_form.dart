import 'package:kafe/widgets/form/submit_button.dart';
import 'package:kafe/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/firebase_auth_provider.dart';

class ProfileForm extends ConsumerStatefulWidget {

  final void Function(String? newUsername, String? newPassword) onSubmit;

  const ProfileForm({super.key, required this.onSubmit});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider.notifier).state;
    if (user != null) {
      _usernameController.text = user.name;
    }
  }

  void _updateProfile() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      final String? newUsername =_usernameController.text.trim().isNotEmpty 
       ?_usernameController.text.trim()
       : null ;
      final String? newPassword = _passwordController.text.trim().isNotEmpty 
       ?_passwordController.text.trim()
       : null ;

      widget.onSubmit(newUsername, newPassword);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextInput(
                label: 'Nom d\'utilisateur',
                controller: _usernameController,
                emptyAllowed: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextInput(
                label: 'Nouveau mot de passe',
                controller: _passwordController,
                obscureText: true,
                emptyAllowed: true,
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