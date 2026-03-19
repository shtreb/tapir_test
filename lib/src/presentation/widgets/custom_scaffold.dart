import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Gradient gradient;
  final Widget child;

  const CustomScaffold({super.key, required this.gradient, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(gradient: gradient),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
