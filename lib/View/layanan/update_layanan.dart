import 'dart:io';

import 'package:app_salon_projek/API/layanan_service.dart';
import 'package:app_salon_projek/model/layanan/get_layanan_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdateLayanan extends StatefulWidget {
  final DataLayanan layanan;
  final VoidCallback? onServiceSaved;

  const UpdateLayanan({super.key, required this.layanan, this.onServiceSaved});

  @override
  State<UpdateLayanan> createState() => _UpdateLayananState();
}

class _UpdateLayananState extends State<UpdateLayanan> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? employeePhoto;
  XFile? servicePhoto;
  bool _isLoading = false;

  // Color palette
  static const Color roseGold = Color(0xFFB76E79);
  static const Color offWhite = Color(0xFFF0F0F0);
  static const Color darkText = Color(0xFF333333);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color warmGold = Color(0xFFE5B39B);

  @override
  void initState() {
    super.initState();
    nameController.text = widget.layanan.name ?? "";
    descriptionController.text = widget.layanan.description ?? "";
    priceController.text = widget.layanan.price.toString();
    employeeNameController.text = widget.layanan.employeeName ?? "";
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthenticationAPIServices.updateServices(
        id: widget.layanan.id ?? 0,
        name: nameController.text,
        description: descriptionController.text,
        price: priceController.text,
        employeeName: employeeNameController.text,
        employeePhoto: employeePhoto != null
            ? File(employeePhoto!.path)
            : File(widget.layanan.employeePhoto ?? ""),
        servicePhoto: servicePhoto != null
            ? File(servicePhoto!.path)
            : File(widget.layanan.servicePhoto ?? ""),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), backgroundColor: roseGold),
      );

      if (widget.onServiceSaved != null) widget.onServiceSaved!();

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengupdate layanan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatBookingPrice(dynamic price) {
    try {
      if (price == null) return 'Rp 0';
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
      return 'Rp 0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Layanan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: roseGold,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: offWhite,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: nameController,
                          label: "Nama Layanan",
                          icon: Icons.spa,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: descriptionController,
                          label: "Deskripsi Layanan",
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: priceController,
                          label: "Harga",
                          icon: Icons.money,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: employeeNameController,
                          label: "Nama Karyawan",
                          icon: Icons.person,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Foto Karyawan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildImageButton(
                              onPressed: pickEmployeePhoto,
                              text: "Ambil Foto Karyawan",
                              icon: Icons.camera_alt,
                            ),
                            const SizedBox(width: 12),
                            _buildImagePreview(
                              employeePhoto,
                              widget.layanan.employeePhoto,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Foto Layanan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildImageButton(
                              onPressed: pickServicePhoto,
                              text: "Ambil Foto Layanan",
                              icon: Icons.photo_camera,
                            ),
                            const SizedBox(width: 12),
                            _buildImagePreview(
                              servicePhoto,
                              widget.layanan.servicePhoto,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(roseGold),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: roseGold,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: darkText),
        prefixIcon: Icon(icon, color: roseGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: roseGold),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? "$label tidak boleh kosong" : null,
      style: const TextStyle(color: darkText),
    );
  }

  Widget _buildImageButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: roseGold,
        side: const BorderSide(color: roseGold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildImagePreview(XFile? newImage, String? existingImagePath) {
    if (newImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(newImage.path),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    } else if (existingImagePath != null && existingImagePath.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(existingImagePath),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: lightGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: warmGold),
        ),
        child: Icon(Icons.image, color: warmGold, size: 40),
      );
    }
  }

  pickEmployeePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        employeePhoto = image;
      });
    }
  }

  pickServicePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        servicePhoto = image;
      });
    }
  }
}
