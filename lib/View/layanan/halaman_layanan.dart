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
      backgroundColor: Colors.pinkAccent.withOpacity(0.2),
      appBar: AppBar(
        title: const Text("Halaman utama"),
        backgroundColor: Color(0xFFD81B60),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/dashboar_salon.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              FutureBuilder<GetLayanan>(
                future: AuthenticationAPIServices.getService(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error : ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    return const Center(child: Text("No service available"));
                  }

                  final serviceList = snapshot.data!.data;
                  return ListView.builder(
                    itemCount: serviceList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final s = serviceList[index];
                      return Dismissible(
                        key: Key(s.id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          AuthenticationAPIServices.deleteService(s.id);
                          setState(() {
                            serviceList.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${s.name} deleted")),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(s.name),

                            trailing: Text("Rp ${s.price}"),
                            onTap: () {
                              context.push(DetailLayanan(isiLayanan: s));
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
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
                                          AuthenticationAPIServices.deleteService(
                                            s.id,
                                          );
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                        child: const Text("Hapus"),
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
              FloatingActionButton(
                onPressed: () {
                  context.push((TambahLayanan())).then((value) {
                    setState(() {});
                  });
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
