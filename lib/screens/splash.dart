import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:anyfest/screens/login_screen.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedSplashScreen(
          duration: 3000,
          nextScreen: const Loginscreen(),
          splash: Image.asset('assets/images/1024.png'),
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: Colors.teal.shade300),
    );
  }
}
