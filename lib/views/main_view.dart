import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kafe/providers/firebase_auth_provider.dart';
import 'package:kafe/views/pages/champ_page.dart';
import 'package:kafe/views/pages/competition_page.dart';
import 'package:kafe/views/pages/stock_page.dart';
import 'package:kafe/widgets/competition/competition_creation_button.dart';
import 'package:kafe/widgets/logout_widget.dart';
import 'package:kafe/widgets/lotti/loading_coffee_widget.dart';

import 'pages/account_page.dart';

class MainView extends HookConsumerWidget {

  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    final selectedIndex = useState(0);

    void onItemTap(int index) {
      selectedIndex.value = index;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(ref.watch(firebaseUser) == null) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).popAndPushNamed('/signIn');
          } else {
            Navigator.of(context).pushNamed('/signIn');
          }
        }
      });
      return null;
    });
    return userAsync.when(
      data: (user) {
        if (user != null) {
          List<Widget> widgetOptions = <Widget>[
            ChampPage(),
            StockPage(user: user),
            CompetitionPage(user: user),
            AccountPage(),
          ];
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Ch'ti Kafé"),
                centerTitle: true,
                bottom: PreferredSize(
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
                      ),
                leading: CompetitionCreationButton(),
                actions: [LogoutWidget()],
              ),
              body: widgetOptions.elementAt(selectedIndex.value),
              bottomNavigationBar: NavigationBar(
                selectedIndex: selectedIndex.value,
                onDestinationSelected: onItemTap,
                destinations: const <NavigationDestination>[
                  NavigationDestination(icon: Icon(Icons.warehouse), label: 'Mes champs'),
                  NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Mon stock'),
                  NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Concours'),
                  NavigationDestination(icon: Icon(Icons.account_circle), label: 'Mon profil'),
                ],
              ),
            ),
          );
        }
        return Center(child: Text("User not found"));
      },
      loading: () => Scaffold(body: Center(child: LoadingCoffeeWidget())),
      error: (err, stack) => Center(child: Text("Erreur : $err")),
    );
      }
}
