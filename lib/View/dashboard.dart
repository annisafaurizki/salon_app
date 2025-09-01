import 'package:flutter/material.dart';

class HalamanDashboard extends StatefulWidget {
  const HalamanDashboard({super.key});

  @override
  State<HalamanDashboard> createState() => _HalamanDashboardState();
}

class _HalamanDashboardState extends State<HalamanDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("halaman utama"),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(60),
               image: DecorationImage(
                image: AssetImage("assets/images/dashboar_salon.jpg"), 
                fit: BoxFit.cover)),
            )
          ],
        ),
      ),
    );
  }
}