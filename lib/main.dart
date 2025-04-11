import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/providers/firebase_auth_provider.dart';
import 'package:kafe/scheduler/initialize_scheduler.dart';
import 'package:kafe/views/main_view.dart';
import 'package:kafe/views/signin_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(firebaseAuthProvider.notifier).initialize();
        initializeScheduler(ref);
      });
      return null;
    });

    return MaterialApp(
      title: 'Kafé',
      theme: ThemeData.light(),
      darkTheme: ThemeData.light(),
      themeMode: ThemeMode.system,
      home:
          (ref.read(firebaseUser) != null)
              ? const MainView()
              : const SigninView(),
      routes: {
        '/home': (context) => const MainView(),
        '/signIn': (context) => const SigninView(),
      },
    );
  }
}
