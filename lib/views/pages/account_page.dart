import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/app_user.dart';
import '../../providers/firebase_auth_provider.dart';
import '../../widgets/account/profile_avatar.dart';
import '../../widgets/form/profile_form.dart';

class AccountPage extends HookConsumerWidget {
  static var int = 0;

  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUser? user = ref.watch(userProvider);
    final isLoading = useState(false);

    void updateProfile(String? newUsername, String? newPassword) async {
      isLoading.value = true;
      if (newUsername != null && newUsername != user!.name) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uuid)
            .update({'name': newUsername});

        user.name = newUsername;
      }

      if (newPassword != null) {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      }

      ref.read(userProvider.notifier).state = user;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès.')),
      );

      isLoading.value = false;
    }

    Future<void> pickImage(ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        const SnackBar(content: Text("Impossible d'uploader votre image, functionnalité payante."));
      }
    }

    return isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Column(
                    children: [
                      ProfileAvatar(
                        imageUrl: null,
                        onTapGallery: () => pickImage(ImageSource.gallery),
                        onTapCamera: () => pickImage(ImageSource.camera),
                      ),
                      const SizedBox(height: 20),
                      ProfileForm(
                        onSubmit:
                            (newUsername, newPassword) =>
                            updateProfile(newUsername, newPassword),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
  }
}
