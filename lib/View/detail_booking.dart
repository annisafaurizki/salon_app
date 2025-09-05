import 'package:app_salon_projek/Model/get_layanan_model.dart';
import 'package:flutter/material.dart';

class DetailBooking extends StatefulWidget {
  final DataLayanan isiLayanan;

  const DetailBooking({super.key, required this.isiLayanan});

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  @override
  Widget build(BuildContext context) {
    final isiLayanan = widget.isiLayanan; // supaya gampang dipanggil

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Layanan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                isiLayanan.servicePhotoUrl.isNotEmpty
                    ? isiLayanan.servicePhotoUrl
                    : "https://via.placeholder.com/300",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // NAMA SERVICE
            Text(
              isiLayanan.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // DESKRIPSI
            Text(
              isiLayanan.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const SizedBox(height: 20),

            // HARGA
            Text(
              "Rp ${isiLayanan.price}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.pink,
              ),
            ),

            const SizedBox(height: 30),

            // TOMBOL BOOKING
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Arahkan ke halaman booking form
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Booking Sekarang",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
