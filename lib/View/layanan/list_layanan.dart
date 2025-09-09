import 'package:app_salon_projek/API/layanan_service.dart';
import 'package:app_salon_projek/Extension/navigator.dart';
import 'package:app_salon_projek/Model/get_layanan_model.dart';
import 'package:app_salon_projek/view/layanan/add_layanan.dart';
import 'package:app_salon_projek/view/layanan/detail_layanan.dart';
import 'package:flutter/material.dart';

class HalamanDashboard extends StatefulWidget {
  const HalamanDashboard({super.key});
  static const id = "/halamandashboard";

  @override
  State<HalamanDashboard> createState() => _HalamanDashboardState();
}

class _HalamanDashboardState extends State<HalamanDashboard> {
  final int _currentIndex = 0;
  late Future<GetLayanan> futureService;

  @override
  void initState() {
    super.initState();
    futureService = AuthenticationAPIServices.getService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // 🎨 light grey background
      appBar: AppBar(
        title: const Text(
          "Salon Services",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
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
            // Judul
            const Text(
              "Our Services",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // FutureBuilder daftar layanan
            FutureBuilder<GetLayanan>(
              future: AuthenticationAPIServices.getService(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.pink),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error : ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                  return const Center(child: Text("No service available"));
                }

                final serviceList = snapshot.data!.data;
                return ListView.builder(
                  itemCount: serviceList?.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final s = serviceList![index];
                    return Dismissible(
                      key: Key(s.id.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        AuthenticationAPIServices.deleteService(s.id ?? 0);
                        setState(() {
                          serviceList.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${s.name} deleted")),
                        );
                      },
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.grey[200],
                              child: const Icon(Icons.spa,
                                  color: Colors.pink, size: 28),
                            ),
                          ),
                          title: Text(
                            s.name ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "Rp ${s.price}",
                            style: const TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            context.push(DetailLayanan(isiLayanan: s));
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text("Hapus Layanan"),
                                  content: const Text(
                                    "Apakah Anda yakin ingin menghapus layanan ini?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        AuthenticationAPIServices
                                            .deleteService(s.id ?? 0);
                                        Navigator.of(context).pop();
                                        setState(() {});
                                      },
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          context.push((TambahLayanan())).then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
