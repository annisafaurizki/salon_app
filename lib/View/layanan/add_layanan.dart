import 'dart:io';

import 'package:app_salon_projek/API/layanan_service.dart';
import 'package:app_salon_projek/Extension/navigator.dart';
import 'package:app_salon_projek/view/layanan/list_layanan.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


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

class TambahLayanan extends StatefulWidget {
  const TambahLayanan({super.key});

  @override
  State<TambahLayanan> createState() => _TambahLayananState();
}

class _TambahLayananState extends State<TambahLayanan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? employeePhoto;
  XFile? servicePhoto;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (employeePhoto == null || servicePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Foto karyawan atau layanan harus diisi"),
            backgroundColor: GlowiesColors.cancelledRed),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthenticationAPIServices.addServices(
        name: nameController.text,
        description: descriptionController.text,
        price: priceController.text,
        employeeName: employeeNameController.text,
        employeePhoto: File(employeePhoto?.path ?? ""),
        servicePhoto: File(servicePhoto?.path ?? ""),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
          content: Text(result.message),
          backgroundColor: GlowiesColors.confirmedGreen));
      context.pop(HalamanDashboard());
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
          content: Text("Gagal menambahkan Layanan: $e"),
          backgroundColor: GlowiesColors.cancelledRed));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlowiesColors.offWhite,
      appBar: AppBar(
        title: const Text(
          "Tambah Layanan",
          style: TextStyle(
            color: GlowiesColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: GlowiesColors.darkText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: GlowiesColors.darkText),
                decoration: InputDecoration(
                  labelText: "Nama Layanan",
                  labelStyle: const TextStyle(color: GlowiesColors.roseGold),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.lightGray),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.roseGold),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                style: const TextStyle(color: GlowiesColors.darkText),
                decoration: InputDecoration(
                  labelText: "Deskripsi Layanan",
                  labelStyle: const TextStyle(color: GlowiesColors.roseGold),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.lightGray),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.roseGold),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: GlowiesColors.darkText),
                decoration: InputDecoration(
                  labelText: "Harga",
                  labelStyle: const TextStyle(color: GlowiesColors.roseGold),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.lightGray),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.roseGold),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: employeeNameController,
                style: const TextStyle(color: GlowiesColors.darkText),
                decoration: InputDecoration(
                  labelText: "Nama Karyawan",
                  labelStyle: const TextStyle(color: GlowiesColors.roseGold),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.lightGray),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: GlowiesColors.roseGold),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                "Foto Karyawan",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GlowiesColors.darkText),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickEmployeePhoto,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text("Ambil Foto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlowiesColors.roseGold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  employeePhoto != null
                      ? Image.file(
                          File(employeePhoto!.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Text("Belum ada foto",
                          style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Foto Layanan",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GlowiesColors.darkText),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickServicePhoto,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text("Ambil Foto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlowiesColors.roseGold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  servicePhoto != null
                      ? Image.file(
                          File(servicePhoto!.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Text("Belum ada foto",
                          style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: GlowiesColors.roseGold))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlowiesColors.roseGold,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Simpan Layanan",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  
  void pickEmployeePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        employeePhoto = image;
      });
    }
  }

  void pickServicePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        servicePhoto = image;
      });
    }
  }
}