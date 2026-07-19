import 'dart:io';
import 'package:get/get.dart';
import '../services/tabungan_service.dart';
import '../models/tabungan_model.dart';

enum TabunganSortMode {
  nameAsc,
  nameDesc,
  nominalAsc,
  nominalDesc,
}

class TabunganController extends GetxController {
  final TabunganService _tabunganService = TabunganService();

  var tabunganList = <Tabungan>[].obs;
  var isLoading = true.obs;
  var isAdding = false.obs;
  var isUpdating = false.obs;
  var currentSortMode = TabunganSortMode.nameAsc.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTabungan();
  }

  // Fetch semua tabungan user
  Future<void> fetchTabungan() async {
    try {
      isLoading(true);
      final tabungan = await _tabunganService.getTabungan();
      tabunganList.assignAll(tabungan);
      applySort();
    } catch (e) {
      print('Error fetching tabungan: $e');
      Get.snackbar('Error', 'Gagal memuat data tabungan');
    } finally {
      isLoading(false);
    }
  }

  void updateSortMode(TabunganSortMode mode) {
    currentSortMode.value = mode;
    applySort();
  }

  void applySort() {
    final sorted = List<Tabungan>.from(tabunganList);

    switch (currentSortMode.value) {
      case TabunganSortMode.nameAsc:
        sorted.sort(
          (a, b) => a.namaTabungan.toLowerCase().compareTo(
            b.namaTabungan.toLowerCase(),
          ),
        );
        break;
      case TabunganSortMode.nameDesc:
        sorted.sort(
          (a, b) => b.namaTabungan.toLowerCase().compareTo(
            a.namaTabungan.toLowerCase(),
          ),
        );
        break;
      case TabunganSortMode.nominalAsc:
        sorted.sort((a, b) => a.targetTabungan.compareTo(b.targetTabungan));
        break;
      case TabunganSortMode.nominalDesc:
        sorted.sort((a, b) => b.targetTabungan.compareTo(a.targetTabungan));
        break;
    }

    tabunganList.assignAll(sorted);
  }

  // Add tabungan baru
  Future<void> addTabungan(Tabungan tabungan) async {
    try {
      isAdding(true);
      await _tabunganService.addTabungan(tabungan);
      await fetchTabungan();
      Get.back();
    } catch (e) {
      print('Error adding tabungan: $e');
      Get.snackbar('Error', 'Gagal menambahkan tabungan');
    } finally {
      isAdding(false);
    }
  }

  // Update tabungan
  Future<void> updateTabungan(Tabungan tabungan) async {
    try {
      isUpdating(true);
      await _tabunganService.updateTabungan(tabungan);
      await fetchTabungan();
      Get.back();
    } catch (e) {
      print('Error updating tabungan: $e');
      Get.snackbar('Error', 'Gagal mengupdate tabungan');
    } finally {
      isUpdating(false);
    }
  }

  // Tambah setoran - DESKRIPSI DIHAPUS
  Future<void> tambahSetoran(
    String tabunganId,
    double jumlah,
    double totalBaru,
  ) async {
    try {
      await _tabunganService.tambahSetoran(
        tabunganId,
        jumlah,
        totalBaru,
      );
      await fetchTabungan(); // Refresh list untuk update progress
    } catch (e) {
      print('Error adding setoran: $e');
      rethrow;
    }
  }

  // Delete tabungan
  Future<void> deleteTabungan(String id) async {
    try {
      await _tabunganService.deleteTabungan(id);
      tabunganList.removeWhere((tabungan) => tabungan.id == id);
      applySort();
    } catch (e) {
      print('Error deleting tabungan: $e');
      Get.snackbar('Error', 'Gagal menghapus tabungan');
    }
  }

  // Upload gambar tabungan
  Future<String?> uploadTabunganImage(File imageFile, String tabunganId) async {
    try {
      final imageUrl = await _tabunganService.uploadTabunganImage(
        imageFile,
        tabunganId,
      );
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Gagal mengupload gambar');
      return null;
    }
  }

  // Get tabungan by ID
  Future<Tabungan?> getTabunganById(String id) async {
    try {
      return await _tabunganService.getTabunganById(id);
    } catch (e) {
      print('Error getting tabungan by ID: $e');
      return null;
    }
  }

  // Update tabungan di list lokal (untuk real-time update)
  void updateTabunganInList(Tabungan updatedTabungan) {
    final index = tabunganList.indexWhere((t) => t.id == updatedTabungan.id);
    if (index != -1) {
      tabunganList[index] = updatedTabungan;
      applySort();
    }
  }
}