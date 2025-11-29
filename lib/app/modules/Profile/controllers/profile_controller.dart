import 'dart:io';
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
        final response =
            await supabase.from('profiles').select().eq('id', user.id).single();

        print('📊 Profile data from DB: $response');

        username.value = response['username'] ?? '';
        phone.value = response['phone'] ?? '';
        email.value = user.email ?? '';
        avatarUrl.value = response['avatar_url'] ?? '';

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
