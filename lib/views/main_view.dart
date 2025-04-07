import 'package:kafe/views/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/firebase_auth_provider.dart';
import '../widgets/logout_widget.dart';
import 'pages/account_page.dart';

class MainView extends HookConsumerWidget {

  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final selectedIndex = useState(0);
    
    const List<Widget> widgetOptions = <Widget> [
      HomePage(),
      Text('Inventaire'),
      Text('Concours'),
      AccountPage(),
    ];
    
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
    const height = 64.0;
    return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Kafé"),
                leading: LogoutWidget(),
              ),
              body: Center(
                child: widgetOptions.elementAt(selectedIndex.value),
              ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex.value,
                onDestinationSelected: onItemTap,
                destinations: const <NavigationDestination> [
                  NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Mes champs'),
                  NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Mon stock'),
                  NavigationDestination(icon: Icon(Icons.star_border), label: 'Concours'),
                  NavigationDestination(icon: Icon(Icons.account_circle), label: 'Mon profil'),
                ])
            /*bottomNavigationBar: const TabBar(tabs: [
              Tab(icon: Icon(Icons.home),height: height, text: "Accueil",),
              Tab(icon: Icon(Icons.account_circle), height: height, text: "Profil",),
            ]),*/
          ),
        );
      }
}
