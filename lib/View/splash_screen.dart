import 'package:app_salon_projek/Share_Preferences/share_preferences.dart';
import 'package:app_salon_projek/View/layanan/salon_home_page.dart';
import 'package:app_salon_projek/view/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLogin = await PreferenceHandler.getLogin();
    await Future.delayed(
      const Duration(seconds: 2),
    ); // biar splash agak lama sedikit

    if (isLogin == true) {
      // Sudah login, pindah ke halaman utama
      Navigator.pushReplacementNamed(context, LoginAPIScreen.id);
    } else {
      // Belum login, pindah ke login screen
      Navigator.pushReplacementNamed(context, SalonHomePage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Glowiessplash.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
