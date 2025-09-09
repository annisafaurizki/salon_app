import 'package:app_salon_projek/view/login.dart';
import 'package:flutter/material.dart';
import 'package:app_salon_projek/api/profile_service.dart';
import 'package:app_salon_projek/model/profile_model.dart';
import 'package:app_salon_projek/share_preferences/share_preferences.dart';


class GlowiesColors {
  static const Color roseGold = Color(0xFFB76E79);
  static const Color offWhite = Color(0xFFF0F0F0);
  static const Color darkText = Color(0xFF333333);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color warmGold = Color(0xFFE5B39B);
}

class HalamanUtamaDua extends StatefulWidget {
  const HalamanUtamaDua({super.key});
  static const id = "/halaman_utama_dua";

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Berhasil Diambil")),
      );
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

  void _logout() async {
    await PreferenceHandler.removeToken();
    await PreferenceHandler.removeLogin();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginAPIScreen.id,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlowiesColors.offWhite,
      appBar: AppBar(
        title: const Text("Profil Akun"),
        centerTitle: true,
        backgroundColor: GlowiesColors.roseGold,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildError()
              : _dataProfile == null
                  ? const Center(child: Text("Tidak ada data"))
                  : _buildProfile(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: GlowiesColors.roseGold,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: GlowiesColors.darkText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: GlowiesColors.roseGold),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: GlowiesColors.roseGold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _ambilData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlowiesColors.roseGold,
              ),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar & Name
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: GlowiesColors.roseGold.withOpacity(0.7),
              child: Text(
                _dataProfile!.data.name.isNotEmpty
                    ? _dataProfile!.data.name[0].toUpperCase()
                    : "?",
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Text(
              _dataProfile!.data.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GlowiesColors.darkText,
              ),
            ),
          ),
          const SizedBox(height: 6),

          Center(
            child: Text(
              _dataProfile!.data.email,
              style: TextStyle(
                fontSize: 16,
                color: GlowiesColors.darkText.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Edit Data Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _showEditDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: GlowiesColors.roseGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Edit Data",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _dataProfile!.data.name);
    final emailController = TextEditingController(text: _dataProfile!.data.email);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Data Profil'),
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
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _isLoading = true;
                });

                try {
                  final result = await ProfileService.updateData(
                    name: nameController.text,
                    email: emailController.text,
                  );

                  if (!mounted) return;
                  setState(() {
                    _dataProfile = result;
                    _isLoading = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perubahan berhasil disimpan!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  setState(() {
                    _isLoading = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menyimpan perubahan: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
