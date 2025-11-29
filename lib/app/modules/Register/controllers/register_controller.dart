import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  final supabase = Supabase.instance.client;

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> register() async {
    if (isLoading.value) return;

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Semua kolom wajib diisi');
      return;
    }

    isLoading.value = true;

    try {
      // REGISTER DENGAN USERNAME DI METADATA
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username}, // Ini yang akan trigger function kita
      );

      if (response.user != null) {
        clearControllers();
        Get.offAllNamed('/login');
      }
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat registrasi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearControllers() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
