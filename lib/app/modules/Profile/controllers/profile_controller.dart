import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  final username = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;

  final isLoading = true.obs;
  final isUploading = false.obs;
  final isUpdating = false.obs;
  final isDeleting = false.obs;
  final isChangingPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    print('🔄 Loading user profile...');

    try {
      final user = supabase.auth.currentUser;
      print('👤 Current user: ${user?.id}');

      if (user != null) {
        email.value = user.email ?? '';

        try {
          final response = await supabase
              .from('profiles')
              .select('username, phone, avatar_url')
              .eq('id', user.id)
              .single();

          print('📊 Profile data from DB: $response');

          username.value =
              response['username']?.toString() ??
              user.userMetadata?['username']?.toString() ??
              user.userMetadata?['nama']?.toString() ??
              'User';
          phone.value = response['phone']?.toString() ?? '';
          avatarUrl.value = response['avatar_url']?.toString() ?? '';
        } catch (e) {
          print('⚠️ Error fetching profile from DB, using metadata: $e');
          username.value =
              user.userMetadata?['username']?.toString() ??
              user.userMetadata?['nama']?.toString() ??
              'User';
          phone.value = '';
          avatarUrl.value = '';
        }

        if (avatarUrl.value.isEmpty) {
          await loadProfilePicture(user.id);
        }

        print(
          '✅ Profile loaded - Username: ${username.value}, Email: ${email.value}',
        );
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProfilePicture(String userId) async {
    try {
      final response = await supabase.storage.from('profile_pictures').list(
        path: userId,
      );

      if (response.isNotEmpty) {
        final String publicUrl = supabase.storage
            .from('profile_pictures')
            .getPublicUrl('$userId/profile.jpg');
        avatarUrl.value = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      } else {
        avatarUrl.value = '';
      }
    } catch (e) {
      print('📸 Error loading profile picture: $e');
      avatarUrl.value = '';
    }
  }

  Future<void> updateProfile({String? username, String? phone}) async {
    isUpdating.value = true;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final updates = {
        if (username != null) 'username': username,
        if (phone != null) 'phone': phone,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('profiles').update(updates).eq('id', user.id);

      // Update observable values
      if (username != null) this.username.value = username;
      if (phone != null) this.phone.value = phone;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> verifyCurrentPassword(String currentPassword) async {
    isChangingPassword.value = true;

    try {
      final user = supabase.auth.currentUser;
      if (user == null || user.email == null || user.email!.isEmpty) {
        throw Exception('User not logged in');
      }

      final trimmedPassword = currentPassword.trim();
      if (trimmedPassword.isEmpty) {
        throw Exception('Password lama harus diisi');
      }

      final response = await supabase.auth.signInWithPassword(
        email: user.email!,
        password: trimmedPassword,
      );

      if (response.user == null) {
        throw Exception('Password lama tidak valid');
      }

      return true;
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      );
      return false;
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<bool> changePassword(String newPassword) async {
    isChangingPassword.value = true;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final trimmedPassword = newPassword.trim();
      if (trimmedPassword.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }

      final hasLetter = RegExp(r'[A-Za-z]').hasMatch(trimmedPassword);
      final hasDigit = RegExp(r'\d').hasMatch(trimmedPassword);
      if (!hasLetter || !hasDigit) {
        throw Exception('Password harus berisi huruf dan angka');
      }

      await supabase.auth.updateUser(
        UserAttributes(password: trimmedPassword),
      );

      Get.snackbar(
        'Berhasil',
        'Password berhasil diubah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF009F61),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      );
      return false;
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    isUploading.value = true;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Upload ke storage
      await supabase.storage
          .from('profile_pictures')
          .upload(
            '${user.id}/profile.jpg',
            imageFile,
            fileOptions: const FileOptions(upsert: true),
          );

      // Dapatkan public URL
      final String publicUrl = supabase.storage
          .from('profile_pictures')
          .getPublicUrl('${user.id}/profile.jpg');

      // Update avatar_url di profiles table
      await supabase
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id);

      // Update observable
      avatarUrl.value = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';

    } catch (e) {
      Get.snackbar('Error', 'Failed to upload photo: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> deleteProfilePicture() async {
    isDeleting.value = true;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Hapus file dari storage
      await supabase.storage.from('profile_pictures').remove([
        '${user.id}/profile.jpg',
      ]);

      // Update avatar_url di profiles table jadi NULL
      await supabase
          .from('profiles')
          .update({'avatar_url': null})
          .eq('id', user.id);

      // Update observable
      avatarUrl.value = '';

    } catch (e) {
      Get.snackbar('Error', 'Failed to delete photo: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        await uploadProfilePicture(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  Future<void> takePhotoFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        await uploadProfilePicture(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil foto: $e');
    }
  }

  Future<bool> logout() async {
    try {
      await supabase.auth.signOut();
      return true;
    } catch (e) {
      print('Error logout: $e');
      return false;
    }
  }
}
