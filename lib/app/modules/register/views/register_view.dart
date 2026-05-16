import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Akun Fillix")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}