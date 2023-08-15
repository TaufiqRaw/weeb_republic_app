import 'package:flutter/material.dart';
import 'package:weeb_republic_app/main.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => App(),
          transitionDuration: Duration(seconds: 2),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),);
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset("assets/splash.png", width: 220),
        ),
      ),
    );
  }
}
