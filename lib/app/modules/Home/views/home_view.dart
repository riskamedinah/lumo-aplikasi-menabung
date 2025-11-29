import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tabungan_controller.dart';
import '../../Home/controllers/home_controller.dart';
import 'add_tabungan_view.dart';
import 'detail_tabungan_view.dart'; // TETAP IMPORT INI
// HAPUS IMPORT edit_tabungan_view.dart
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  final TabunganController _tabunganController = Get.put(TabunganController());
  final HomeController _homeController = Get.put(HomeController());
  
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() {
          if (_homeController.isLoading.value) {
            return const SizedBox.shrink();
          }
          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello,',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    _homeController.nama.value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
        actions: [
          Obx(() {
            if (_homeController.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF009F61),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/profile');
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF009F61).withOpacity(0.1),
                  backgroundImage:
                      _homeController.fotoProfile.value.isNotEmpty
                          ? NetworkImage(_homeController.fotoProfile.value)
                          : null,
                  child:
                      _homeController.fotoProfile.value.isEmpty
                          ? Text(
                            _homeController.nama.value.isNotEmpty
                                ? _homeController.nama.value[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Color(0xFF009F61),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                          : null,
                ),
              ),
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF009F61),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF009F61),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF009F61).withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // TODO: Filter by name
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nama Tabungan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF009F61),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF009F61).withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // TODO: Sort/Order
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Urutkan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabungan List
            Expanded(
              child: Obx(() {
                if (_tabunganController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF009F61)),
                  );
                }

                if (_tabunganController.tabunganList.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF009F61).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 80,
                                color: Color(0xFF009F61),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Belum ada tabungan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mulai perjalanan menabung Anda\ndengan menekan tombol +',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _tabunganController.tabunganList.length,
                  itemBuilder: (context, index) {
                    final tabungan = _tabunganController.tabunganList[index];

                    // PROGRESS DINAMIS - dari database
                    final progress = tabungan.progress;
                    final progressPercentage = (progress * 100).toInt();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            // NAVIGASI KE DETAIL TABUNGAN
                            Get.to(
                              () => DetailTabunganView(tabungan: tabungan),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header dengan Nama Tabungan
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tabungan.namaTabungan,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF009F61),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: Colors.grey[400],
                                        size: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      itemBuilder:
                                          (context) => [
                                            // HAPUS MENU EDIT
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete_outline,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          _showDeleteConfirmation(
                                            context,
                                            tabungan.id,
                                            tabungan.namaTabungan,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Gambar Tabungan
                                Container(
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF009F61,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child:
                                      tabungan.gambarUrl != null &&
                                              tabungan.gambarUrl!.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Image.network(
                                              tabungan.gambarUrl!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Center(
                                                  child: Icon(
                                                    Icons.photo_outlined,
                                                    size: 50,
                                                    color: Colors.grey[400],
                                                  ),
                                                );
                                              },
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value:
                                                        loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                    color: const Color(
                                                      0xFF009F61,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                          : Center(
                                            child: Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              size: 50,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                ),

                                const SizedBox(height: 16),

                                // Target Amount & Progress
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatCurrency(tabungan),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_formatNominal(tabungan)} Per${tabungan.rencanaPengisian}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Terkumpul: Rp ${_formatNumber(tabungan.totalTerkumpul)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Circular Progress Indicator - DINAMIS
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CircularProgressIndicator(
                                            value: progress,
                                            strokeWidth: 5,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(Color(0xFF009F61)),
                                          ),
                                          Center(
                                            child: Text(
                                              '$progressPercentage%',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF009F61),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Progress Bar Linear
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF009F61),
                                      ),
                                  borderRadius: BorderRadius.circular(10),
                                  minHeight: 6,
                                ),

                                const SizedBox(height: 8),

                                // Progress Text
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatNumber(tabungan.totalTerkumpul),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF009F61),
                                      ),
                                    ),
                                    Text(
                                      _formatNumber(tabungan.targetTabungan),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddTabunganView());
        },
        backgroundColor: const Color(0xFF009F61),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Fungsi untuk refresh data
  Future<void> _refreshData() async {
    try {
      // Refresh data profil
      await _homeController.fetchUserData();

      // Refresh data tabungan
      await _tabunganController.fetchTabungan();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, String id, String nama) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Hapus Tabungan'),
              ],
            ),
            content: Text(
              'Apakah Anda yakin ingin menghapus "$nama"? Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                onPressed: () {
                  _tabunganController.deleteTabungan(id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }

  String _formatCurrency(tabungan) {
    final symbol = _getCurrencySymbol(tabungan.mataUang);
    return '$symbol ${_formatNumber(tabungan.targetTabungan)}';
  }

  String _formatNominal(tabungan) {
    final symbol = _getCurrencySymbol(tabungan.mataUang);
    return '$symbol ${_formatNumber(tabungan.nominalPengisian)}';
  }

  String _getCurrencySymbol(String mataUang) {
    if (mataUang.contains('(') && mataUang.contains(')')) {
      final start = mataUang.indexOf('(') + 1;
      final end = mataUang.indexOf(')');
      return mataUang.substring(start, end);
    }
    return 'Rp';
  }

  String _formatNumber(double number) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number).replaceAll(',', '.');
  }
}
