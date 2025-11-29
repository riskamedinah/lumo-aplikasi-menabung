import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/tabungan_controller.dart';
import '../models/tabungan_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AddTabunganView extends StatefulWidget {
  const AddTabunganView({super.key});

  @override
  State<AddTabunganView> createState() => _AddTabunganViewState();
}

class _AddTabunganViewState extends State<AddTabunganView> {
  final TabunganController _controller = Get.find<TabunganController>();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  String _selectedRencana = 'harian';
  File? _selectedImage;
  final NumberFormat _numberFormat = NumberFormat("#,##0", "id_ID");

  String _formatNumber(String value) {
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

  // Method untuk memilih gambar
  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Method untuk mengambil foto
  Future<void> _takePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Tampilkan bottom sheet untuk pilih gambar
  void _showImagePickerModal() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF009F61),
              ),
              title: const Text('Pilih dari Gallery'),
              onTap: () {
                Get.back();
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF009F61)),
              title: const Text('Ambil Foto'),
              onTap: () {
                Get.back();
                _takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF009F61)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Tabungan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Section Gambar Tabungan
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Gambar Tabungan'),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: _showImagePickerModal,
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child:
                                  _selectedImage != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: 40,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tambahkan Gambar',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Section Form Data Tabungan
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Nama Tabungan'),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _namaController,
                              style: const TextStyle(fontSize: 15),
                              decoration: _buildInputDecoration(
                                hint: 'Contoh: Tabungan Liburan',
                                prefixIcon: Icons.edit_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama tabungan harus diisi';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            _buildSectionLabel('Target Tabungan'),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _targetController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 15),
                              decoration: _buildInputDecoration(
                                hint: '0',
                                prefixIcon:
                                    Icons.account_balance_wallet_outlined,
                                prefix: 'Rp ',
                              ),
                              onChanged: (value) {
                                final formatted = _formatNumber(value);
                                if (formatted != value) {
                                  _targetController.value = TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.collapsed(
                                      offset: formatted.length,
                                    ),
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Target tabungan harus diisi';
                                }
                                final numericValue = _parseFormattedNumber(
                                  value,
                                );
                                if (numericValue <= 0) {
                                  return 'Target harus lebih dari 0';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Section Rencana Pengisian
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Rencana Pengisian'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildRencanaOption(
                                'Harian',
                                'harian',
                                Icons.wb_sunny_outlined,
                              ),
                              const SizedBox(width: 10),
                              _buildRencanaOption(
                                'Mingguan',
                                'mingguan',
                                Icons.date_range_outlined,
                              ),
                              const SizedBox(width: 10),
                              _buildRencanaOption(
                                'Bulanan',
                                'bulanan',
                                Icons.calendar_month_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionLabel('Nominal Pengisian'),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nominalController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 15),
                            decoration: _buildInputDecoration(
                              hint: '0',
                              prefixIcon: Icons.attach_money,
                              prefix: 'Rp ',
                            ),
                            onChanged: (value) {
                              final formatted = _formatNumber(value);
                              if (formatted != value) {
                                _nominalController.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(
                                    offset: formatted.length,
                                  ),
                                );
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nominal pengisian harus diisi';
                              }
                              final numericValue = _parseFormattedNumber(value);
                              if (numericValue <= 0) {
                                return 'Nominal harus lebih dari 0';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _controller.isAdding.value ? null : _saveTabungan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009F61),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _controller.isAdding.value
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Simpan Tabungan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData prefixIcon,
    String? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      prefixText: prefix,
      prefixStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(prefixIcon, color: Colors.grey[400], size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        borderSide: const BorderSide(color: Color(0xFF009F61), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Widget _buildRencanaOption(String text, String value, IconData icon) {
    final isSelected = _selectedRencana == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedRencana = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF009F61).withOpacity(0.1)
                    : Colors.grey[50],
            border: Border.all(
              color: isSelected ? const Color(0xFF009F61) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? const Color(0xFF009F61) : Colors.grey[600],
              ),
              const SizedBox(height: 6),
              Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isSelected ? const Color(0xFF009F61) : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTabungan() async {
    if (_formKey.currentState!.validate()) {
      String? gambarUrl;

      // Upload gambar jika ada
      if (_selectedImage != null) {
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        gambarUrl = await _controller.uploadTabunganImage(
          _selectedImage!,
          tempId,
        );
      }

      final tabungan = Tabungan(
        id: '',
        userId: '',
        namaTabungan: _namaController.text,
        targetTabungan: _parseFormattedNumber(_targetController.text),
        totalTerkumpul: 0, // Default 0
        mataUang: 'Indonesia Rupiah (Rp)',
        rencanaPengisian: _selectedRencana,
        nominalPengisian: _parseFormattedNumber(_nominalController.text),
        gambarUrl: gambarUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _controller.addTabungan(tabungan);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _targetController.dispose();
    _nominalController.dispose();
    super.dispose();
  }
}
