import 'package:app_salon_projek/API/layanan_service.dart';
import 'package:app_salon_projek/Extension/navigator.dart';
import 'package:app_salon_projek/View/dashboard.dart';
import 'package:flutter/material.dart';

class TambahLayanan extends StatefulWidget {
  const TambahLayanan({super.key});

  @override
  State<TambahLayanan> createState() => _TambahLayananState();
}

class _TambahLayananState extends State<TambahLayanan> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =  TextEditingController();
  final TextEditingController descriptionController =  TextEditingController();
  final TextEditingController priceController=  TextEditingController();
  final TextEditingController employeeNameController =  TextEditingController();
  
  bool _isLoading = false;

  Future<void> _submitForm() async{
    if (!_formKey.currentState!.validate())
    return;

    setState(() {
      _isLoading = true;
    });


    try {
      final result = await AuthenticationAPIServices.addServices(
        name: nameController.text, 
        description: descriptionController.text, 
        price: int.parse(priceController.text), 
        employeeName: employeeNameController.text,
        employeePhoto: "",
        servicePhoto: "",
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message))
      );
      context.pop(HalamanDashboard());
        
    } catch (e) {

       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text ("Gagal menambahkan Layanan: $e")));
    
    }finally{
    setState(() {
      _isLoading = false;
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Layanan"),),
      body: Padding(padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child:ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama Layanan"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama tidak boleh kosong";
                }
                return null;
              }
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Deskripsi Layanan"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Deskripsi tidak boleh kosong";
                }
                return null;
              }
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: "Harga"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Harga tidak boleh kosong";
                }
                return null;
              }
            ),
            TextFormField(
              controller: employeeNameController,
              decoration: InputDecoration(labelText: "Nama Karyawan"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nama tidak boleh kosong";
                }
                return null;
              }
            ),
            SizedBox(height: 24,),
            _isLoading
            ? const Center(child: CircularProgressIndicator(),)
            : ElevatedButton(onPressed: _submitForm, child: Text("Simpan"))
          ],
        ) ),
      ),
    );

  }
}