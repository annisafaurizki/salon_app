import 'package:app_salon_projek/api/booking_service.dart';
import 'package:app_salon_projek/extension/navigator.dart';
import 'package:app_salon_projek/view/layanan/list_layanan.dart';
import 'package:flutter/material.dart';

// Dummy kategori
final List<Map<String, dynamic>> categories = [
  {"name": "Potong Rambut", "icon": Icons.content_cut},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // light grey background
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
                    "Location",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.pink),
                    onPressed: () {},
                  )
                ],
              ),
              const Text(
                "Jakarta, Indonesia",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              
              TextField(
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: "Search services...",
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "New Service",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Diskon 20% untuk transaksi pertama!",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.spa, size: 64, color: Colors.pink),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("See All", style: TextStyle(color: Colors.pink)),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categories.map((cat) {
                  return GestureDetector(
                    onTap: () {
                      if (cat["name"] == "Potong Rambut") {
                        context.push(HalamanDashboard());
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
                          backgroundColor: Colors.grey[200],
                          child: Icon(cat["icon"], color: Colors.pink),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat["name"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
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
                children: const [
                  Text(
                    "Riwayat Booking",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("See All", style: TextStyle(color: Colors.pink)),
                ],
              ),

              const SizedBox(height: 12),
              


const SizedBox(height: 12),

FutureBuilder(
  future: BookingService.getBookings(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text("Error: ${snapshot.error}");
    }
    if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
      return const Text("Belum ada riwayat booking");
    }

    final bookings = snapshot.data!.data;

    return Column(
      children: bookings.take(3).map((b) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.event, color: Colors.pink),
            title: Text("Service ID: ${b.serviceId}"),
            subtitle: Text("Tanggal: ${b.bookingTime}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              
            },
          ),
        );
      }).toList(),
    );
  },
),

            ],
          ),
        ),
      ),
    );
  }
}
