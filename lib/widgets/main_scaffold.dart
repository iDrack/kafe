import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? leadingWidget;

  const MainScaffold( {
    super.key, 
    required this.title,
    required this.body,
    this.leadingWidget, this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        leading: leadingWidget,
        title: Text(title),
      ),
      body: body,
    );
  }
}