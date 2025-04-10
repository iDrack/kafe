import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class NotFoundWidget extends StatelessWidget {
  final String title;

  const NotFoundWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'lib/assets/animations/notFound.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          repeat: false,
        ),
        Text(title),
      ],
    );
  }
}
