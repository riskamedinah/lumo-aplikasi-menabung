import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/tabungan_controller.dart';
import '../models/tabungan_model.dart';

class TambahSetoranBottomSheet extends StatefulWidget {
  final Tabungan tabungan;

  const TambahSetoranBottomSheet({super.key, required this.tabungan});

  @override
  State<TambahSetoranBottomSheet> createState() =>
      _TambahSetoranBottomSheetState();
}

class _TambahSetoranBottomSheetState extends State<TambahSetoranBottomSheet> {
  final TabunganController _controller = Get.find<TabunganController>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat("#,##0", "id_ID");

  bool _isLoading = false;

  // Method untuk format input
  String _formatInputNumber(String value) {
    if (value.isEmpty) return '';
    String digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isNotEmpty) {
      int number = int.parse(digits);
      return _numberFormat.format(number);
    }
    return '';
  }

  double _parseFormattedNumber(String formatted) {
    if (formatted.isEmpty) return 0;
    String digits = formatted.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isNotEmpty) {
      return double.parse(digits);
    }
    return 0;
  }

  Future<void> _tambahSetoran() async {
    if (_jumlahController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Jumlah setoran harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final jumlah = _parseFormattedNumber(_jumlahController.text);
    if (jumlah <= 0) {
      Get.snackbar(
        'Error',
        'Jumlah setoran harus lebih dari 0',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Hitung total baru
      final totalBaru = widget.tabungan.totalTerkumpul + jumlah;

      // Update di database
      await _controller.tambahSetoran(
        widget.tabungan.id,
        jumlah,
        totalBaru,
        _deskripsiController.text.isNotEmpty
            ? _deskripsiController.text
            : 'Setoran',
      );

      // Tutup bottom sheet
      Get.back();

      // Navigasi ke HomeView setelah delay singkat
      await Future.delayed(Duration(milliseconds: 1500));
      Get.until((route) => route.isFirst); // Kembali ke home
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan setoran: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.tabungan.progress;
    final progressPercentage = (progress * 100).toInt();

    return SingleChildScrollView(
      // TAMBAHKAN INI - FIX OVERFLOW
      child: Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tambah Setoran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Info Tabungan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF009F61).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    widget.tabungan.namaTabungan,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF009F61),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '$progressPercentage%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF009F61),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Terkumpul',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Rp ${_formatDisplayNumber(widget.tabungan.totalTerkumpul)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF009F61),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF009F61),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 6,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form Setoran
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jumlah Setoran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _jumlahController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0',
                    prefixText: 'Rp ',
                    prefixStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF009F61),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    final formatted = _formatInputNumber(value);
                    if (formatted != value) {
                      _jumlahController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(
                          offset: formatted.length,
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 16),

                const Text(
                  'Deskripsi (Opsional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    hintText: 'Contoh: Setoran bulan Januari',
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF009F61),
                        width: 2,
                      ),
                    ),
                  ),
                  maxLines: 2,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _tambahSetoran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009F61),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Tambah Setoran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Method untuk format display
  String _formatDisplayNumber(double number) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number).replaceAll(',', '.');
  }
}
