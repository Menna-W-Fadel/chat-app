import 'package:chat_app/core/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        Navigator.pushReplacementNamed(context, Routes.mainScreen);
      } else {
        Navigator.pushReplacementNamed(context, Routes.loginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/icons/Drop A Line.json',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}
