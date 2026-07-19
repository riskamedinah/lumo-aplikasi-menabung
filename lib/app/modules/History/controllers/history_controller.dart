import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumo/app/modules/Home/models/tabungan_model.dart';
import 'package:lumo/app/modules/Home/services/tabungan_service.dart';

class HistoryController extends GetxController {
  final TabunganService _tabunganService = TabunganService();

  final completedTabunganList = <Tabungan>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompletedTabungan();
  }

  Future<void> fetchCompletedTabungan() async {
    try {
      isLoading.value = true;
      final tabungan = await _tabunganService.getTabungan();
      completedTabunganList.assignAll(
        tabungan.where((item) => item.isTargetTercapai).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat tabungan');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTabungan(String id) async {
    try {
      await _tabunganService.deleteTabungan(id);
      completedTabunganList.removeWhere((tabungan) => tabungan.id == id);
      Get.snackbar(
        'Berhasil',
        'Riwayat tabungan berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF009F61),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menghapus riwayat tabungan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      );
    }
  }
}
