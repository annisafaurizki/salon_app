import 'package:app_salon_projek/api/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Palet Warna Kustom ---
class GlowiesColors {
  static const Color roseGold = Color(0xFFB76E79);
  static const Color offWhite = Color(0xFFF0F0F0);
  static const Color darkText = Color(0xFF333333);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color warmGold = Color(0xFFE5B39B);
}

class BookingFormPage extends StatefulWidget {
  final int serviceId;
  final String serviceName;
  final String servicePrice;

  const BookingFormPage({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  DateTime? _selectedDateTime;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: GlowiesColors.roseGold,
              onPrimary: Colors.white,
              onSurface: GlowiesColors.darkText,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: GlowiesColors.roseGold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: GlowiesColors.roseGold,
                onPrimary: Colors.white,
                onSurface: GlowiesColors.darkText,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: GlowiesColors.roseGold,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitBooking() async {
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Silakan pilih tanggal & jam terlebih dahulu"),
          backgroundColor: GlowiesColors.darkText,
        ),
      );
      return;
    }

    if (_selectedDateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Tidak bisa memilih waktu yang sudah lewat"),
          backgroundColor: GlowiesColors.darkText,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final booking = await BookingApiService.addBooking(
        serviceId: widget.serviceId,
        bookingTime: _selectedDateTime!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ ${booking.message}"),
          backgroundColor: GlowiesColors.darkText,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Error: $e"),
            backgroundColor: GlowiesColors.darkText,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? formattedDate = _selectedDateTime != null
        ? DateFormat('dd MMMM yyyy').format(_selectedDateTime!)
        : null;

    final String? formattedTime = _selectedDateTime != null
        ? DateFormat('HH:mm').format(_selectedDateTime!)
        : null;

    final String? dayName =
        _selectedDateTime != null ? _getDayName(_selectedDateTime!) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Layanan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: GlowiesColors.darkText,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: GlowiesColors.darkText,
      ),
      backgroundColor: GlowiesColors.offWhite,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CARD INFO LAYANAN
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Layanan yang dipilih:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.serviceName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: GlowiesColors.darkText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp ${widget.servicePrice}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: GlowiesColors.roseGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // SECTION PILIH WAKTU
              const Text(
                "Pilih Waktu Booking",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GlowiesColors.darkText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Pilih tanggal dan jam yang sesuai untuk layanan Anda",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              // TOMBOL PILIH WAKTU
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickDateTime,
                  icon: const Icon(Icons.calendar_today, size: 20),
                  label: const Text(
                    "Pilih Tanggal & Jam",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: GlowiesColors.roseGold,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                          color: GlowiesColors.roseGold, width: 1.5),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // TAMPILAN WAKTU YANG DIPILIH
              if (_selectedDateTime != null)
                Card(
                  color: GlowiesColors.offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                        color: GlowiesColors.roseGold, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_month,
                                color: GlowiesColors.roseGold, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              formattedDate!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: GlowiesColors.darkText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time,
                                color: GlowiesColors.roseGold, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "$formattedTime • $dayName",
                              style: const TextStyle(
                                fontSize: 14,
                                color: GlowiesColors.darkText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(),

              // TOMBOL KONFIRMASI
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlowiesColors.roseGold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Konfirmasi Booking",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 8),

              // TOMBOL BATAL
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text(
                    "Batalkan",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}