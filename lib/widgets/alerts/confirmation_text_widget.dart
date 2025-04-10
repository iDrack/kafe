import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class ConfirmationTextWidget extends StatelessWidget {
  final String title;

  const ConfirmationTextWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'lib/assets/animations/think.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          repeat: true,
        ),
        Text(title),
      ],
    );
  }
}
