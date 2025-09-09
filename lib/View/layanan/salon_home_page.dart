import 'package:app_salon_projek/api/booking_service.dart';
import 'package:app_salon_projek/extension/navigator.dart';
import 'package:app_salon_projek/model/booking/get_booking.dart';
import 'package:app_salon_projek/view/booking/update_booking.dart';
import 'package:app_salon_projek/view/home_api.dart';
import 'package:app_salon_projek/view/layanan/list_layanan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlowiesColors {
  static const Color roseGold = Color(0xFFB76E79);
  static const Color offWhite = Color(0xFFF0F0F0);
  static const Color darkText = Color(0xFF333333);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color warmGold = Color(0xFFE5B39B);
  static const Color confirmedGreen = Color(0xFF6B9F8D);
  static const Color cancelledRed = Color(0xFFE07A7A);
  static const Color pendingOrange = Color(0xFFE0C47A);
  static const Color completedBlue = Color(0xFF7A9FE0);
}

final List<Map<String, dynamic>> categories = [
  {"name": "Rambut", "icon": Icons.content_cut},
  {"name": "Nail Art", "icon": Icons.brush},
  {"name": "Make Up", "icon": Icons.face_retouching_natural},
  {"name": "Baju", "icon": Icons.checkroom},
];

class SalonHomePage extends StatefulWidget {
  const SalonHomePage({super.key});

  @override
  State<SalonHomePage> createState() => _SalonHomePageState();
}

class _SalonHomePageState extends State<SalonHomePage> {
  String searchQuery = "";
  late Future<List<BookingData>> _futureBookings;
  List<BookingData> _allBookings = []; // Menyimpan semua data booking

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    setState(() {
      _futureBookings = BookingApiService.getBookingHistory().then((bookings) {
        _allBookings = bookings; // Simpan semua data booking
        return bookings;
      });
    });
  }

  // Fungsi untuk memfilter booking berdasarkan query pencarian
  List<BookingData> _filterBookings(List<BookingData> bookings, String query) {
    if (query.isEmpty) {
      return bookings;
    }
    
    return bookings.where((booking) {
      // Cari di berbagai field booking
      final serviceName = booking.service.name.toLowerCase();
      final bookingDate = DateFormat('dd MMM yyyy - HH:mm')
          .format(booking.bookingTime)
          .toLowerCase();
      final status = booking.status.toLowerCase();
      final price = _formatBookingPrice(booking.service.price).toLowerCase();
      
      final queryLower = query.toLowerCase();
      
      return serviceName.contains(queryLower) ||
          bookingDate.contains(queryLower) ||
          status.contains(queryLower) ||
          price.contains(queryLower);
    }).toList();
  }

  // Fungsi untuk memformat harga dengan aman
  String _formatBookingPrice(dynamic price) {
    try {
      if (price == null) return 'Rp 0';
      print('Price data: $price, Type: ${price.runtimeType}');

      if (price is String && price.contains('Rp')) {
        return price;
      }

      final numericValue = double.tryParse(price.toString());
      if (numericValue != null) {
        final format = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        );
        return format.format(numericValue);
      }

      return 'Rp 0';
    } catch (e) {
      print('Error formatting price: $e');
      return 'Rp 0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlowiesColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Lokasi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: GlowiesColors.darkText,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: GlowiesColors.roseGold),
                    onPressed: () {
                      context.push(const HalamanUtamaDua());
                    },
                  ),
                ],
              ),
              const Text(
                "Jakarta, Indonesia",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // TextField Pencarian
              TextField(
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Cari layanan, tanggal, atau status...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                height: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/glowies_homepage.png"),
                    fit: BoxFit.cover,
                  ),
                  color: GlowiesColors.warmGold,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Kategori",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlowiesColors.darkText),
                  ),
                  Text("Lihat Semua",
                      style: TextStyle(color: GlowiesColors.roseGold)),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categories.map((cat) {
                  return GestureDetector(
                    onTap: () {
                      if (cat["name"] == "Rambut") {
                        context.push(const HalamanDashboard());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("${cat["name"]} belum tersedia")),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: GlowiesColors.lightGray,
                          child:
                              Icon(cat["icon"], color: GlowiesColors.roseGold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat["name"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: GlowiesColors.darkText,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Janji Temu ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlowiesColors.darkText),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _loadBookings,
                    color: GlowiesColors.roseGold,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              FutureBuilder<List<BookingData>>(
                future: _futureBookings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: GlowiesColors.roseGold));
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            "Gagal memuat data: ${snapshot.error}",
                            style: const TextStyle(color: GlowiesColors.cancelledRed),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _loadBookings,
                            child: const Text("Coba Lagi", style: TextStyle(color: GlowiesColors.roseGold)),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: GlowiesColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.event_note, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "Belum ada riwayat booking",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final allBookings = snapshot.data!;
                  // Filter booking berdasarkan query pencarian
                  final filteredBookings = _filterBookings(allBookings, searchQuery);

                  // Tampilkan pesan jika tidak ada hasil pencarian
                  if (searchQuery.isNotEmpty && filteredBookings.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: GlowiesColors.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off, size: 40, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            "Tidak ditemukan hasil untuk '$searchQuery'",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  // Tampilkan semua booking jika tidak ada pencarian, atau hasil yang difilter
                  final bookingsToShow = searchQuery.isEmpty 
                      ? allBookings.take(3).toList() 
                      : filteredBookings;

                  return Column(
                    children: bookingsToShow.map((booking) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: GlowiesColors.roseGold),
                          title: Text(
                            booking.service.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: GlowiesColors.darkText),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatBookingPrice(booking.service.price),
                                style: const TextStyle(
                                  color: GlowiesColors.roseGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMM yyyy - HH:mm')
                                    .format(booking.bookingTime),
                                style: const TextStyle(fontSize: 12, color: GlowiesColors.darkText),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(booking.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  booking.status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.grey),
                          onTap: () {
                            context.push(EditBookingPage(booking: booking))
                                .then((_) {
                              _loadBookings();
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return GlowiesColors.confirmedGreen;
      case 'pending':
        return GlowiesColors.pendingOrange;
      case 'cancelled':
        return GlowiesColors.cancelledRed;
      case 'completed':
        return GlowiesColors.completedBlue;
      default:
        return Colors.grey;
    }
  }
}