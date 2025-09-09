import 'package:app_salon_projek/api/booking_service.dart';
import 'package:app_salon_projek/model/booking/get_booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingActivePage extends StatefulWidget {
  const BookingActivePage({super.key});

  @override
  State<BookingActivePage> createState() => _BookingActivePageState();
}

class _BookingActivePageState extends State<BookingActivePage> {
  late Future<List<BookingData>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = BookingApiService.getBookingHistory();
  }

  // Function untuk warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Function untuk icon status
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.access_time;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingData>>(
      future: _futureBookings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("❌ Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada booking aktif"));
        }

        // filter status = pending / confirmed
        final bookings = snapshot.data!
            .where(
              (b) =>
                  b.status.toLowerCase() == "pending" ||
                  b.status.toLowerCase() == "confirmed",
            )
            .toList();

        if (bookings.isEmpty) {
          return const Center(child: Text("Belum ada booking aktif"));
        }

        return Column(
          children: [
            // --- HEADER INFO ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Kamu memiliki ${bookings.length} booking aktif",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),

            // --- LIST BOOKING ---
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final service = booking.service;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Header Service
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  service.servicePhotoUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.spa, 
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Rp ${service.price}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(booking.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(_getStatusIcon(booking.status),
                                        size: 14, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      booking.status.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // --- Info Booking
                          Text(
                            "Dipesan: ${DateFormat('dd MMM yyyy, HH:mm').format(booking.bookingTime)}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Nama Karyawan (jika ada)
                          if (service.employeeName.isNotEmpty)
                            Text(
                              "Dikerjakan oleh: ${service.employeeName}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}