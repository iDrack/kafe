import 'package:flutter/cupertino.dart';
        import 'package:hooks_riverpod/hooks_riverpod.dart';
        import 'package:kafe/widgets/fruits/fruit_card.dart';

        import '../../models/app_user.dart';
        import '../../models/kafe.dart';

        class FruitList extends HookConsumerWidget {
          final AppUser user;

          const FruitList({super.key, required this.user});

          @override
          Widget build(BuildContext context, WidgetRef ref) {
            void secher(Kafe kafe) {
              print(kafe.nom);
                  print(user.quantiteKafe[kafe]);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FruitCard(kafe: Kafe.Rubisca, poid: user.quantiteKafe[Kafe.Rubisca] ?? 0.0, onPressed: () => secher(Kafe.Rubisca)),
                  FruitCard(kafe: Kafe.Goldoriat, poid: user.quantiteKafe[Kafe.Goldoriat] ?? 0.0, onPressed: () => secher(Kafe.Goldoriat)),
                  FruitCard(kafe: Kafe.Arbrista, poid: user.quantiteKafe[Kafe.Arbrista] ?? 0.0, onPressed: () => secher(Kafe.Arbrista)),
                  FruitCard(kafe: Kafe.Roupetta, poid: user.quantiteKafe[Kafe.Roupetta] ?? 0.0, onPressed: () => secher(Kafe.Roupetta)),
                  FruitCard(kafe: Kafe.Tourista, poid: user.quantiteKafe[Kafe.Tourista] ?? 0.0, onPressed: () => secher(Kafe.Tourista)),
                ],
              ),
            );
          }
        }