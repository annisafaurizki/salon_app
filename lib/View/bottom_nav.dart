import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    // HalamanDashboard(), // ini dashboard kamu
    // TambahLayanan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // ganti isi body sesuai tab
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            selectedColor: Colors.pink,
          ),
          CrystalNavigationBarItem(
            icon: Icons.plus_one_outlined,
            selectedColor: Colors.amber,
          ),
          CrystalNavigationBarItem(
            icon: Icons.watch_later,
            selectedColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
