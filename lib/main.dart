import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:anyfest/screens/login_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ANYFEST',
      home: AnimatedSplashScreen(
          nextScreen: const Loginscreen(),
          splash: Image.asset('assets/images/1024.png'),
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: Colors.teal.shade300),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
