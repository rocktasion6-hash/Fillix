import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Akun Fillix")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(labelText: "Email Baru"),
            ),
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 30),
            Obx(() => controller.isLoading.value 
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: controller.register,
                  child: Text("Daftar Sekarang"),
                )),
          ],
        ),
      ),
    );
  }
}