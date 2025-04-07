import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/firebase_auth_provider.dart';

class LogoutWidget extends ConsumerWidget {

  LogoutWidget({super.key});

  Future<void> handleLogout(BuildContext context, WidgetRef ref) async {
    ref.watch(firebaseAuthProvider.notifier).logout();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(onPressed: () async => await handleLogout(context, ref), icon: const Icon(Icons.logout));
  }
}