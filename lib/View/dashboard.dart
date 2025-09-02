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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
               image: DecorationImage(
                image: AssetImage("assets/images/poster_dashboard.jpg"), 
                fit: BoxFit.cover)),
            ),

            SizedBox(height: 20,),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.amber),
                ),
                SizedBox(width: 10,),
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.amber),
                ),
              
                SizedBox(width: 10,),
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.amber),
                ),
              
                SizedBox(width: 10,),
                Container(
                  height: 150,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.amber),
                )
                ],
              ),
            )
          ],
        ),

      ),
    );
  }
}