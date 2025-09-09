import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_salon_projek/api/booking_service.dart';
import 'package:app_salon_projek/model/booking/get_booking.dart'; // supaya pakai BookingData

class EditBookingPage extends StatefulWidget {
  final BookingData booking;

  const EditBookingPage({super.key, required this.booking});

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _statusController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();

    _statusController = TextEditingController(text: widget.booking.status);

    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(widget.booking.bookingTime),
    );
  }

  @override
  void dispose() {
    _statusController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _updateBooking() async {
  try {
    // parse string ke DateTime sesuai format controller
    final bookingTime =
        DateFormat("yyyy-MM-dd HH:mm").parse(_dateController.text);

    final updatedBooking = await BookingApiService.updateBooking(
      id: widget.booking.id,
      serviceId: widget.booking.service.id, // akses id dari service
      bookingTime: bookingTime, // ini udah ada variabelnya
      status: _statusController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updatedBooking.message)),
      );
      Navigator.pop(context, true); // kirim flag refresh
    }
  }   catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: "Status"),
            ),
            const SizedBox(height: 16),

            // Tanggal Booking
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Tanggal Booking"),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.booking.bookingTime,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (pickedDate != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(widget.booking.bookingTime),
                  );

                  if (pickedTime != null) {
                    final newDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    setState(() {
                      _dateController.text =
                          DateFormat('yyyy-MM-dd HH:mm').format(newDateTime);
                    });
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _updateBooking,
              child: const Text("Update Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
