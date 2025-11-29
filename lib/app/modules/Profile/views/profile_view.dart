import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../views/edit_profile_screen.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());

  // HAPUS SEMUA METHOD YANG BERHUBUNGAN DENGAN EDIT FOTO
  // _showImagePickerModal() dan _showDeleteConfirmation() dihapus

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildProfileSection(),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildMenuItem(
                                icon: 'assets/images/edit.svg',
                                title: 'Edit Profil',
                                onTap: () {
                                  Get.to(() => EditProfileScreen());
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildMenuItem(
                                icon: 'assets/images/lock.svg',
                                title: 'Ubah Password',
                                onTap: () {},
                              ),
                              const SizedBox(height: 14),
                              _buildMenuItem(
                                icon: 'assets/images/backup.svg',
                                title: 'Backup dan Restore',
                                onTap: () {},
                              ),
                              const SizedBox(height: 14),
                              _buildMenuItem(
                                icon: 'assets/images/logout.svg',
                                title: 'Log Out',
                                onTap: _showLogoutConfirmation,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        // HAPUS GestureDetector dan Stack, ganti dengan CircleAvatar biasa
        Obx(() {
          return CircleAvatar(
            radius: 55,
            backgroundColor: const Color(0xFF009F61).withOpacity(0.1),
            backgroundImage:
                controller.avatarUrl.value.isNotEmpty
                    ? NetworkImage(controller.avatarUrl.value)
                    : null,
            child:
                controller.avatarUrl.value.isEmpty
                    ? Text(
                      controller.username.value.isNotEmpty
                          ? controller.username.value[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Color(0xFF009F61),
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    )
                    : null,
          );
        }),
        const SizedBox(height: 18),
        Text(
          controller.username.value.isNotEmpty
              ? controller.username.value
              : 'User',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          controller.email.value,
          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF009F61),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF009F61).withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 24, height: 24, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apakah Anda yakin ingin keluar?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        Get.dialog(
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const CircularProgressIndicator(
                                color: Color(0xFF009F61),
                              ),
                            ),
                          ),
                          barrierDismissible: false,
                        );
                        bool success = await controller.logout();
                        Get.back();
                        if (success) {
                          Get.offAllNamed('/login');
                        } else {
                          Get.snackbar(
                            'Gagal',
                            'Gagal logout. Silakan coba lagi',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            borderRadius: 12,
                            margin: const EdgeInsets.all(20),
                            duration: const Duration(seconds: 2),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF009F61),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
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
            ],
          ),
        ),
      ),
    );
  }
}
