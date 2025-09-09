import 'package:app_salon_projek/view/home_api.dart';
import 'package:app_salon_projek/view/login.dart';
import 'package:flutter/material.dart';
import 'package:app_salon_projek/view/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ms. Beauty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        LoginAPIScreen.id: (context) => const LoginAPIScreen(),
        HalamanUtamaDua.id: (context) => const HalamanUtamaDua(),
      },
    );
  }
}
