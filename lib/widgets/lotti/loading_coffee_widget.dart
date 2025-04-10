import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class LoadingCoffeeWidget extends StatelessWidget {

  const LoadingCoffeeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'lib/assets/animations/coffeeLoading.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          repeat: false,
        ),
        Text("Chargement en cours"),
      ],
    );
  }
}
