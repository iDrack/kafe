import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GatoStatCard extends HookWidget {
  final String title;
  final num value;

  const GatoStatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final nbStars = (value.ceil() / 10);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              children: [
                ...List.generate(
                  nbStars.toInt(),
                  (index) => Icon(Icons.star, color: Color(0xFFd8cf1c)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
