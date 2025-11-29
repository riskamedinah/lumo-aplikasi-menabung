// controllers/home_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;

  var nama = ''.obs;
  var fotoProfile = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading(true);

      final user = supabase.auth.currentUser;
      if (user != null) {
        print('🏠 Fetching home data for user: ${user.id}');

        // ✅ AMBIL DATA DARI TABLE PROFILES (SINKRON DENGAN PROFILE CONTROLLER)
        try {
          final profileResponse =
              await supabase
                  .from('profiles')
                  .select('username, avatar_url')
                  .eq('id', user.id)
                  .single();

          print('📊 Home profile data: $profileResponse');

          // ✅ GUNAKAN USERNAME DARI PROFILES TABLE
          nama.value =
              profileResponse['username']?.toString() ??
              user.userMetadata?['username']?.toString() ??
              user.userMetadata?['nama']?.toString() ??
              'User';

          // ✅ FOTO PROFILE DARI PROFILES TABLE (avatar_url)
          fotoProfile.value = profileResponse['avatar_url']?.toString() ?? '';

          print('✅ Home data loaded - Username: $nama, Foto: $fotoProfile');
        } catch (e) {
          print('⚠️ Error fetching from profiles, using metadata: $e');
          // Fallback ke metadata kalau error
          nama.value =
              user.userMetadata?['username']?.toString() ??
              user.userMetadata?['nama']?.toString() ??
              'User';
          fotoProfile.value = '';
        }

        // ✅ CEK FOTO DI STORAGE JIKA avatar_url KOSONG
        if (fotoProfile.value.isEmpty) {
          await loadProfilePicture(user.id);
        }
      }
    } catch (e) {
      print('❌ Error fetching home data: $e');
      final user = supabase.auth.currentUser;
      nama.value = user?.userMetadata?['nama']?.toString() ?? 'User';
      fotoProfile.value = '';
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadProfilePicture(String userId) async {
    try {
      final response = await supabase.storage
          .from('profile_pictures')
          .list(path: userId);

      // ✅ CEK APAKAH FILE BENAR-BENAR ADA
      if (response.isNotEmpty) {
        final String publicUrl = supabase.storage
            .from('profile_pictures')
            .getPublicUrl('$userId/profile.jpg');
        fotoProfile.value =
            '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
        print('📸 Loaded profile picture from storage: $fotoProfile');
      } else {
        fotoProfile.value = '';
        print('📸 No profile picture in storage');
      }
    } catch (e) {
      print('📸 Error loading profile picture: $e');
      fotoProfile.value = '';
    }
  }

  Future<void> refreshData() async {
    print('🔄 Refreshing home data...');
    await fetchUserData();
  }
}
