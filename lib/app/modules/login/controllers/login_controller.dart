import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  // Observable variables untuk UI
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  // Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    Get.snackbar("Error", "Email dan Password wajib diisi",
        backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  isLoading.value = true;
  try {
    final response = await _authProvider.signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (response.user != null) {
      // Mengambil role terbaru dari tabel profiles
      String role = await _authProvider.getUserRole(response.user!.id);
      
      Get.snackbar("Sukses", "Selamat datang kembali!");
      
      // Kirim data role ke Home
      Get.offAllNamed(Routes.HOME, arguments: role);
    }
  } catch (e) {
    // Memberikan pesan error yang lebih manusiawi
    Get.snackbar("Login Gagal", "Email atau password salah",
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}