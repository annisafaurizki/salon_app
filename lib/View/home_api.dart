import 'package:app_salon_projek/api/profile_service.dart';
import 'package:app_salon_projek/model/profile_model.dart';
import 'package:app_salon_projek/share_preferences/share_preferences.dart';
import 'package:app_salon_projek/view/login.dart';
import 'package:flutter/material.dart';

class GlowiesColors {
  static const Color roseGold = Color(0xFFB76E79);
  static const Color offWhite = Color(0xFFF0F0F0);
  static const Color darkText = Color(0xFF333333);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color warmGold = Color(0xFFE5B39B);
  static const Color lightPink = Color(0xFFFFF0F5);
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
      appBar: AppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildError()
          : _dataProfile == null
          ? const Center(child: Text("Tidak ada data"))
          : _buildProfile(),
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
              style: TextStyle(fontSize: 16, color: GlowiesColors.darkText),
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
                foregroundColor: Colors.white,
              ),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header dengan gradient
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [GlowiesColors.roseGold, GlowiesColors.warmGold],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: GlowiesColors.roseGold.withOpacity(0.8),
                    child: Text(
                      _dataProfile!.data.name.isNotEmpty
                          ? _dataProfile!.data.name[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _dataProfile!.data.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _dataProfile!.data.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.calendar_today,
                  value: "12",
                  label: "Janji Temu",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.star,
                  value: "4.8",
                  label: "Rating",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Menu Options
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildMenuOption(
                  icon: Icons.person,
                  title: "Edit Profil",
                  subtitle: "Ubah data pribadi Anda",
                  onTap: _showEditDialog,
                ),
                _buildDivider(),
                _buildMenuOption(
                  icon: Icons.price_change_sharp,
                  title: "Dompet Glowies",
                  subtitle: "Pembayaran jadi lebih mudah",
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuOption(
                  icon: Icons.notifications,
                  title: "Notifikasi",
                  subtitle: "Keluar notifikasi Anda",
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuOption(
                  icon: Icons.help,
                  title: "Bantuan",
                  subtitle: "Pusat bantuan dan dukungan",
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: GlowiesColors.lightPink,
                foregroundColor: GlowiesColors.roseGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.logout),
              label: const Text(
                "Keluar Akun",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: GlowiesColors.roseGold),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: GlowiesColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: GlowiesColors.darkText.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: GlowiesColors.roseGold.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: GlowiesColors.roseGold),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: GlowiesColors.darkText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: GlowiesColors.darkText.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: GlowiesColors.darkText.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: GlowiesColors.lightGray),
    );
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _dataProfile!.data.name);
    final emailController = TextEditingController(
      text: _dataProfile!.data.email,
    );

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
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: GlowiesColors.roseGold,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
