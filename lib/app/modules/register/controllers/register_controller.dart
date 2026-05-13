import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  var isLoading = false.obs;

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() async {
    // 1. Validasi Input
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error", 
        "Semua kolom harus diisi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    try {
      // 2. Proses SignUp ke Supabase
      final response = await _authProvider.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // 3. Logika Navigasi Setelah Berhasil
      if (response.user != null) {
        // Cek jika butuh konfirmasi email (session akan null jika email belum dikonfirmasi)
        if (response.session == null) {
          Get.defaultDialog(
            title: "Registrasi Berhasil",
            middleText: "Silakan cek email Anda untuk melakukan verifikasi sebelum login.",
            textConfirm: "OK",
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back(); // Tutup Dialog
              Get.offAllNamed(Routes.LOGIN); // Paksa ke halaman Login
            },
          );
        } else {
          // Jika konfirmasi email mati, user bisa langsung diarahkan
          Get.snackbar(
            "Sukses", 
            "Akun berhasil dibuat!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offAllNamed(Routes.LOGIN);
        }
      }
    } catch (e) {
      // 4. Penanganan Error
      Get.snackbar(
        "Registrasi Gagal", 
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose untuk mencegah memory leak
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}