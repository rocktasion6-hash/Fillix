import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Fillix")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            Obx(() => TextField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(controller.isPasswordVisible.value 
                    ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => controller.isPasswordVisible.toggle(),
                ),
              ),
            )),
            SizedBox(height: 20),
            Obx(() => controller.isLoading.value 
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: controller.login,
                  child: Text("Login"),
                )),
            TextButton(
              onPressed: () => Get.toNamed(Routes.REGISTER),
              child: Text("Belum punya akun? Daftar disini"),
            )
          ],
        ),
      ),
    );
  }
}