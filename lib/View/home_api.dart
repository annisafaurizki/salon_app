import 'package:flutter/material.dart';
import 'package:salon_app/API/profile_service.dart';
import 'package:salon_app/Model/profile_model.dart';


class HalamanUtamaDua extends StatefulWidget {
  const HalamanUtamaDua({super.key});

  @override
  State<HalamanUtamaDua> createState() => _HalamanUtamaDuaState();
}

class _HalamanUtamaDuaState extends State<HalamanUtamaDua> {
  ProfileModel? _dataProfile;
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _ambilData() async {
    try {
      final ambilData = await ProfileService.getProfile();
      if (!mounted) return;
      setState(() {
        _dataProfile = ambilData;
        _isLoading = false;
        _errorMessage = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data Berhasil Diambil")));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _ambilData();
                },
                child: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    if (_dataProfile == null) {
      return const Center(child: Text("Tidak ada data"));
    }

    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nama: ${_dataProfile!.data.name}"),
          Text("Email: ${_dataProfile!.data.email}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final parentContext = context; // simpan context utama

              showDialog(
                context: context,
                builder: (dialogContext) {
                  final nameController = TextEditingController(
                    text: _dataProfile!.data.name,
                  );
                  final emailController = TextEditingController(
                    text: _dataProfile!.data.email,
                  );

                  return AlertDialog(
                    title: const Text('Edit Data'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Nama'),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();

                          try {
                            setState(() => _isLoading = true);

                            final result = await ProfileService.updateData(
                              name: nameController.text,
                              email: emailController.text,
                            );

                            if (!mounted) return;
                            setState(() {
                              _dataProfile = result;
                              _isLoading = false;
                            });

                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content: Text('Perubahan berhasil disimpan!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menyimpan perubahan: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 45),
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("Edit Data"),
          ),
        ],
      ),
    );
  }
}
