
import 'package:app_salon_projek/View/bottom_nav.dart';
import 'package:app_salon_projek/View/login_api_screen.dart';

import 'package:flutter/material.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ms. Beauty",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: BottomNav()
    );
  }
}