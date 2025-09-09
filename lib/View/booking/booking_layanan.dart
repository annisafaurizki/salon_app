import 'package:app_salon_projek/api/booking_service.dart';
import 'package:app_salon_projek/extension/navigator.dart';
import 'package:app_salon_projek/view/layanan/list_layanan.dart';
import 'package:flutter/material.dart';
import 'package:app_salon_projek/Model/get_layanan_model.dart';

class BookingPage extends StatefulWidget {
  final DataLayanan layanan;
  const BookingPage({super.key, required this.layanan});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> submitBooking() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih tanggal & waktu dulu")),
      );
      return;
    }
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi nama dan nomor HP dulu")),
      );
      return;
    }

    final bookingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // 👉 format "2025-06-20T14:00:00"
    final bookingTimeStr = bookingDateTime.toIso8601String().split('.').first;

    setState(() => isLoading = true);

    try {
      final result = await BookingService.addServices(
        serviceId: widget.layanan.id.toString(),
        bookingTime: bookingTimeStr,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message ?? "Booking berhasil!")),
      );
      if (mounted) context.pop(HalamanDashboard());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal booking: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String two(int n) => n.toString().padLeft(2, '0');

    final selectedTimeText = selectedTime == null
        ? "Pilih Waktu"
        : "${two(selectedTime!.hour)}:${two(selectedTime!.minute)}";

    final selectedDateText = selectedDate == null
        ? "Pilih Tanggal"
        : "${two(selectedDate!.day)}/${two(selectedDate!.month)}/${selectedDate!.year}";

    return Scaffold(
      appBar: AppBar(title: const Text("Booking Layanan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Service otomatis
            Text(
              "Layanan: ${widget.layanan.name}",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Input Nama Customer
            TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Nama Customer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Input Nomor HP
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: "Nomor HP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Pilih tanggal
            ListTile(
              title: Text(selectedDateText),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) setState(() => selectedDate = date);
              },
            ),

            // Pilih waktu
            ListTile(
              title: Text(selectedTimeText),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() => selectedTime = time);
                }
              },
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : submitBooking,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Konfirmasi Booking",
                        style: TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
