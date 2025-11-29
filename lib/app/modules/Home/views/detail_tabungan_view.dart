import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../controllers/tabungan_controller.dart';
import '../models/tabungan_model.dart';
import 'tambah_setoran_bottom_sheet.dart';

class DetailTabunganView extends StatefulWidget {
  final Tabungan tabungan;

  const DetailTabunganView({super.key, required this.tabungan});

  @override
  State<DetailTabunganView> createState() => _DetailTabunganViewState();
}

class _DetailTabunganViewState extends State<DetailTabunganView> {
  bool _isDateFormatInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDateFormat();
  }

  Future<void> _initializeDateFormat() async {
    try {
      await initializeDateFormatting('id_ID', null);
      setState(() {
        _isDateFormatInitialized = true;
      });
    } catch (e) {
      print('Error initializing date format: $e');
      // Tetap set true agar UI bisa render dengan fallback
      setState(() {
        _isDateFormatInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDateFormatInitialized) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF009F61)),
              ),
              SizedBox(height: 16),
              Text(
                'Memuat...',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return _buildContent();
  }

  Widget _buildContent() {
    final TabunganController _controller = Get.find<TabunganController>();
    final progress = widget.tabungan.progress;
    final progressPercentage = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.tabungan.namaTabungan,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.edit_outlined, color: Color(0xFF009F61)),
          //   onPressed: () {
          //     Get.snackbar(
          //       'Info',
          //       'Fitur edit akan segera tersedia',
          //       backgroundColor: Colors.orange,
          //       colorText: Colors.white,
          //     );
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Tabungan
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF009F61).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  widget.tabungan.gambarUrl != null &&
                          widget.tabungan.gambarUrl!.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.tabungan.gambarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.photo_outlined,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                            );
                          },
                        ),
                      )
                      : Center(
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      ),
            ),

            const SizedBox(height: 24),

            // Progress Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  // Progress Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '$progressPercentage%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF009F61),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF009F61),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 12,
                  ),

                  const SizedBox(height: 12),

                  // Amount Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terkumpul',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${_formatNumber(widget.tabungan.totalTerkumpul)}',
                            style: const TextStyle(
                              fontSize: 18,
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
                            'Target',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${_formatNumber(widget.tabungan.targetTabungan)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Tabungan
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Tabungan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoItem(
                    'Rencana Pengisian',
                    _capitalizeFirst(widget.tabungan.rencanaPengisian),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    'Nominal Pengisian',
                    'Rp ${_formatNumber(widget.tabungan.nominalPengisian)}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    'Tanggal Dibuat',
                    _formatDate(widget.tabungan.createdAt),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tombol Tambah Setoran
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showTambahSetoranBottomSheet(widget.tabungan, _controller);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009F61),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tambah Setoran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      // Fallback manual formatting jika intl gagal
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  String _formatNumber(double number) {
    try {
      final formatter = NumberFormat('#,##0', 'id_ID');
      return formatter.format(number).replaceAll(',', '.');
    } catch (e) {
      // Fallback manual formatting
      return number
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
    }
  }

 void _showTambahSetoranBottomSheet(
    Tabungan tabungan,
    TabunganController controller,
  ) {
    Get.bottomSheet(
      TambahSetoranBottomSheet(tabungan: tabungan),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
