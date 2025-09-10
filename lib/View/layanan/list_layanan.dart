import 'package:app_salon_projek/API/layanan_service.dart';
import 'package:app_salon_projek/Extension/navigator.dart';
import 'package:app_salon_projek/View/layanan/update_layanan.dart';
import 'package:app_salon_projek/model/layanan/get_layanan_model.dart';
import 'package:app_salon_projek/view/layanan/add_layanan.dart';
import 'package:app_salon_projek/view/layanan/detail_layanan.dart';
import 'package:flutter/material.dart';

class GlowiesColors {
  static const Color roseGold = Color(0xFFE6CFA9);
  static const Color warmGold = Color(0xFFE5B39B);
  static const Color offWhite = Color(0xFFF0F0F0);
  static const Color lightGray = Color(0xFF443627);
}

class HalamanDashboard extends StatefulWidget {
  const HalamanDashboard({super.key});
  static const id = "/halamandashboard";

  @override
  State<HalamanDashboard> createState() => _HalamanDashboardState();
}

class _HalamanDashboardState extends State<HalamanDashboard> {
  late Future<GetLayanan> futureService;

  @override
  void initState() {
    super.initState();
    futureService = AuthenticationAPIServices.getService();
  }

  Future<void> _deleteService(
    int id,
    int index,
    List<DataLayanan> serviceList,
  ) async {
    try {
      bool success = await AuthenticationAPIServices.deleteService(id);
      if (success) {
        setState(() {
          serviceList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Layanan berhasil dihapus")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ Gagal hapus layanan")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlowiesColors.offWhite,
      appBar: AppBar(
        title: const Text(
          "Perawatan Rambut",
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
            FutureBuilder<GetLayanan>(
              future: AuthenticationAPIServices.getService(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: GlowiesColors.roseGold,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                  return const Center(child: Text("No service available"));
                }

                final serviceList = snapshot.data!.data!;
                return ListView.builder(
                  itemCount: serviceList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final s = serviceList[index];
                    return Dismissible(
                      key: Key(s.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.redAccent,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Hapus Layanan"),
                            content: Text(
                              "Apakah Anda yakin ingin menghapus '${s.name}'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        _deleteService(s.id ?? 0, index, serviceList);
                      },
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
                              color: GlowiesColors.lightGray,
                              child: const Icon(
                                Icons.spa,
                                color: GlowiesColors.roseGold,
                                size: 28,
                              ),
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
                              color: GlowiesColors.lightGray,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Tambahkan di bagian trailing ListTile
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: GlowiesColors.roseGold,
                                ),
                                onPressed: () {
                                  // Navigasi ke halaman UpdateLayanan dengan data layanan
                                  context.push(UpdateLayanan(layanan: s)).then((
                                    value,
                                  ) {
                                    setState(
                                      () {},
                                    ); // Refresh list setelah update
                                  });
                                },
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: GlowiesColors.lightGray,
                              ),
                            ],
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
                                  content: Text(
                                    "Apakah Anda yakin ingin menghapus '${s.name}'?",
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
                                        Navigator.of(context).pop();
                                        _deleteService(
                                          s.id ?? 0,
                                          index,
                                          serviceList,
                                        );
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
        backgroundColor: GlowiesColors.roseGold,
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
