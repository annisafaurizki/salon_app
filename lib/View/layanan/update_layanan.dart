import 'dart:io';

import 'package:app_salon_projek/API/layanan_service.dart';
import 'package:app_salon_projek/Extension/navigator.dart';
import 'package:app_salon_projek/model/layanan/get_layanan_model.dart';
import 'package:app_salon_projek/view/layanan/list_layanan.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateLayanan extends StatefulWidget {
  final DataLayanan layanan;

  const UpdateLayanan({super.key, required this.layanan});

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

  @override
  void initState() {
    super.initState();
    nameController.text = widget.layanan.name ?? "";
    descriptionController.text = widget.layanan.description ?? "";
    priceController.text = widget.layanan.price.toString();
    employeeNameController.text = widget.layanan.employeeName ?? "";
  }

  Future<void> _submitForm() async {
    if (employeePhoto == null || servicePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto karyawan atau layanan harus diisi")),
      );
      return;
    }
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
      context.pop(HalamanDashboard());
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengupdate Layanan: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Layanan")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nama Layanan"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Deskripsi Layanan"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi tidak boleh kosong";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Harga"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga tidak boleh kosong";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: employeeNameController,
                decoration: InputDecoration(labelText: "Nama Karyawan"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              Text("Foto Karyawan"),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: pickEmployeePhoto,
                    child: Text("Ambil Foto Karyawan"),
                  ),
                  SizedBox(width: 12),
                  employeePhoto != null
                      ? Image.file(
                          File(employeePhoto!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.layanan.employeePhoto ?? ""),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ],
              ),
              SizedBox(height: 12),
              Text("Foto Layanan"),
              SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: pickServicePhoto,
                    child: Text("Ambil Foto Layanan"),
                  ),
                  SizedBox(width: 12),
                  servicePhoto != null
                      ? Image.file(
                          File(servicePhoto!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.layanan.servicePhoto ?? ""),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ],
              ),
              SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: Text("Simpan"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  pickEmployeePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print(image);
    print(image?.path);
    setState(() {
      employeePhoto = image;
    });
    if (image == null) {
      return;
    } else {
      // final response = await CategoriesAPI.postCategory(
      //   name: "ACAK",
      //   image: File(image.path),
      // );
    }
  }

  pickServicePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print(image);
    print(image?.path);
    setState(() {
      servicePhoto = image;
    });
    if (image == null) {
      return;
    } else {
      // final response = await CategoriesAPI.postCategory(
      //   name: "ACAK",
      //   image: File(image.path),
      // );
    }
  }
}
