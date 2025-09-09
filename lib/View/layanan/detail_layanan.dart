import 'package:app_salon_projek/Extension/navigator.dart';
import 'package:app_salon_projek/Model/get_layanan_model.dart';
import 'package:app_salon_projek/view/booking/booking_layanan.dart';
import 'package:flutter/material.dart';

class DetailLayanan extends StatefulWidget {
  final DataLayanan isiLayanan;

  const DetailLayanan({super.key, required this.isiLayanan});

  @override
  State<DetailLayanan> createState() => _DetailLayananState();
}

class _DetailLayananState extends State<DetailLayanan> {
  @override
  Widget build(BuildContext context) {
    final isiLayanan = widget.isiLayanan;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Detail Layanan",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                isiLayanan.servicePhotoUrl ?? "https://via.placeholder.com/300",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // NAMA SERVICE
            Text(
              isiLayanan.name ?? "",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // ⭐ Rating Dummy
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star, color: Colors.amber, size: 20),
                Icon(Icons.star_half, color: Colors.amber, size: 20),
                SizedBox(width: 6),
                Text(
                  "4.5 (120 reviews)",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // DESKRIPSI
            Text(
              isiLayanan.description ?? "Tidak ada deskripsi layanan",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // INFORMASI TAMBAHAN
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.pink, size: 20),
                const SizedBox(width: 6),
                Text(
                  "Estimasi durasi: 45 menit",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // HARGA DALAM CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Harga",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Rp ${isiLayanan.price}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SECTION KENAPA MEMILIH
            const Text(
              "Kenapa memilih layanan ini?",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              "✦ Ditangani oleh profesional berpengalaman\n"
              "✦ Menggunakan peralatan steril & aman\n"
              "✦ Banyak pelanggan puas dengan hasilnya",
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
            ),

            const SizedBox(height: 30),

            // TOMBOL BOOKING
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.push(BookingPage(layanan: widget.isiLayanan));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Booking Sekarang",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
