import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set initial values ke text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usernameController.text = controller.username.value;
      phoneController.text = controller.phone.value;
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Picture Section
                      _buildProfilePictureSection(),
                      const SizedBox(height: 30),

                      // Form Fields
                      _buildFormSection(),
                      const SizedBox(height: 30),

                      // Save Button
                      _buildSaveButton(),

                      // HAPUS TOMBOL HAPUS PROFIL DI SINI
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _showImagePickerModal,
          child: Stack(
            children: [
              Obx(() {
                if (controller.isUploading.value) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                return CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF009F61).withOpacity(0.1),
                  backgroundImage:
                      controller.avatarUrl.value.isNotEmpty
                          ? NetworkImage(controller.avatarUrl.value)
                          : null,
                  child:
                      controller.avatarUrl.value.isEmpty
                          ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Color(0xFF009F61),
                          )
                          : null,
                );
              }),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF009F61),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Ubah Foto Profil',
          style: TextStyle(
            color: const Color(0xFF009F61),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Username Field
          _buildTextField(
            controller: usernameController,
            label: 'Username',
            hintText: '',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),

          // Phone Field
          _buildTextField(
            controller: phoneController,
            label: 'Nomor Telepon',
            hintText: 'Masukkan nomor telepon',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          // Email Field (Read-only)
          _buildEmailField(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(icon, color: const Color(0xFF009F61)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ListTile(
            leading: const Icon(Icons.email_outlined, color: Colors.grey),
            title: Text(
              controller.email.value,
              style: const TextStyle(color: Colors.grey),
            ),
            enabled: false,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Email tidak dapat diubah',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              controller.isUpdating.value
                  ? null
                  : () async {
                    await controller.updateProfile(
                      username: usernameController.text.trim(),
                      phone: phoneController.text.trim(),
                    );
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009F61),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child:
              controller.isUpdating.value
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }

  // HAPUS METHOD _buildDeleteProfileButton() SELURUHNYA

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
                controller.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF009F61)),
              title: const Text('Ambil Foto'),
              onTap: () {
                Get.back();
                controller.takePhotoFromCamera();
              },
            ),
            // TAMBAHKAN OPSI HAPUS FOTO - SELALU TAMPIL JIKA ADA FOTO
            Obx(
              () =>
                  controller.avatarUrl.value.isNotEmpty
                      ? ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text(
                          'Hapus Foto',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Get.back();
                          _showDeletePhotoConfirmation();
                        },
                      )
                      : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeletePhotoConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Foto Profil'),
        content: const Text('Apakah Anda yakin ingin menghapus foto profil?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteProfilePicture();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
