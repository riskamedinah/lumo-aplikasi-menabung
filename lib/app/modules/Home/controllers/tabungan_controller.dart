import 'dart:io';
import 'package:get/get.dart';
import '../services/tabungan_service.dart';
import '../models/tabungan_model.dart';

class TabunganController extends GetxController {
  final TabunganService _tabunganService = TabunganService();

  var tabunganList = <Tabungan>[].obs;
  var isLoading = true.obs;
  var isAdding = false.obs;
  var isUpdating = false.obs;

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
    } catch (e) {
      print('Error fetching tabungan: $e');
      Get.snackbar('Error', 'Gagal memuat data tabungan');
    } finally {
      isLoading(false);
    }
  }

  // Add tabungan baru
  Future<void> addTabungan(Tabungan tabungan) async {
    try {
      isAdding(true);
      await _tabunganService.addTabungan(tabungan);
      await fetchTabungan(); // Refresh list
      Get.back(); // Kembali ke previous screen
    } catch (e) {
      print('Error adding tabungan: $e');
      Get.snackbar('Error', 'Gagal menambahkan tabungan');
    } finally {
      isAdding(false);
    }
  }

  // TAMBAHKAN METHOD INI: Update tabungan
  Future<void> updateTabungan(Tabungan tabungan) async {
    try {
      isUpdating(true);
      await _tabunganService.updateTabungan(tabungan);
      await fetchTabungan(); // Refresh list
      Get.back(); // Kembali ke detail screen
    } catch (e) {
      print('Error updating tabungan: $e');
      Get.snackbar('Error', 'Gagal mengupdate tabungan');
    } finally {
      isUpdating(false);
    }
  }

  // TAMBAHKAN METHOD INI: Tambah setoran
  Future<void> tambahSetoran(
    String tabunganId,
    double jumlah,
    double totalBaru,
    String deskripsi,
  ) async {
    try {
      await _tabunganService.tambahSetoran(
        tabunganId,
        jumlah,
        totalBaru,
        deskripsi,
      );
      await fetchTabungan(); // Refresh list untuk update progress
    } catch (e) {
      print('Error adding setoran: $e');
      rethrow; // Lempar error ke caller (bottom sheet)
    }
  }

  // Delete tabungan
  Future<void> deleteTabungan(String id) async {
    try {
      await _tabunganService.deleteTabungan(id);
      tabunganList.removeWhere((tabungan) => tabungan.id == id);
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

  // TAMBAHKAN METHOD INI: Get tabungan by ID
  Future<Tabungan?> getTabunganById(String id) async {
    try {
      return await _tabunganService.getTabunganById(id);
    } catch (e) {
      print('Error getting tabungan by ID: $e');
      return null;
    }
  }

  // TAMBAHKAN METHOD INI: Update tabungan di list lokal (untuk real-time update)
  void updateTabunganInList(Tabungan updatedTabungan) {
    final index = tabunganList.indexWhere((t) => t.id == updatedTabungan.id);
    if (index != -1) {
      tabunganList[index] = updatedTabungan;
    }
  }
}
