import 'package:kafe/views/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/views/pages/stock_page.dart';

import '../models/app_user.dart';
import '../providers/firebase_auth_provider.dart';
import '../providers/user_stream_provider.dart';
import '../widgets/logout_widget.dart';
import 'pages/account_page.dart';

class MainView extends HookConsumerWidget {

  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    final selectedIndex = useState(0);

    final showMoney = useState(true);

    useEffect(() {
      showMoney.value = (selectedIndex.value == 0 || selectedIndex.value == 3);
      return null;
    }, [selectedIndex.value]);

    void onItemTap(int index) {
      selectedIndex.value = index;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(ref.watch(firebaseUser) == null) {
          Navigator.of(context).popAndPushNamed("/signIn");
        }
      });
      return null;
    });
    return userAsync.when(
      data: (user) {
        if (user != null) {
          List<Widget> widgetOptions = <Widget>[
            HomePage(),
            StockPage(user: user),
            Text('Concours'),
            AccountPage(),
          ];
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Ch'ti Kafé"),
                centerTitle: true,
                bottom: (showMoney.value)
                    ? PreferredSize(
                        preferredSize: const Size.fromHeight(20.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text("💎 : ${user.deevee ?? 0}"),
                              SizedBox(width: 16.0),
                              Text("🪙 : ${user.goldenSeed ?? 0}"),
                            ],
                          ),
                        ),
                      )
                    : null,
                leading: SizedBox(),
                actions: [LogoutWidget()],
              ),
              body: widgetOptions.elementAt(selectedIndex.value),
              bottomNavigationBar: NavigationBar(
                selectedIndex: selectedIndex.value,
                onDestinationSelected: onItemTap,
                destinations: const <NavigationDestination>[
                  NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Mes champs'),
                  NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Mon stock'),
                  NavigationDestination(icon: Icon(Icons.star_border), label: 'Concours'),
                  NavigationDestination(icon: Icon(Icons.account_circle), label: 'Mon profil'),
                ],
              ),
            ),
          );
        }
        return Center(child: Text("User not found"));
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Erreur : $err")),
    );
      }
}
