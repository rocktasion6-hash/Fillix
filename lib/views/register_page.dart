import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> register() async {

    if (passwordController.text !=
        confirmPasswordController.text) {

      Get.snackbar(
        "Error",
        "Password tidak sama",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      await Supabase.instance.client.auth
          .signUp(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      Get.snackbar(
        "Sukses",
        "Registrasi berhasil",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();

    } on AuthException catch (e) {

      Get.snackbar(
        "Register Gagal",
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: Center(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            children: [

              const Icon(
                Icons.person_add,
                color: Colors.red,
                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(
                "Buat Akun Fillix",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // EMAIL
              TextField(

                controller:
                emailController,

                style: const TextStyle(
                    color: Colors.white),

                decoration: InputDecoration(

                  hintText: "Email",

                  hintStyle:
                  const TextStyle(
                    color: Colors.grey,
                  ),

                  filled: true,

                  fillColor:
                  Colors.grey.shade900,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                        12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD
              TextField(

                controller:
                passwordController,

                obscureText: true,

                style: const TextStyle(
                    color: Colors.white),

                decoration: InputDecoration(

                  hintText: "Password",

                  hintStyle:
                  const TextStyle(
                    color: Colors.grey,
                  ),

                  filled: true,

                  fillColor:
                  Colors.grey.shade900,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                        12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD
              TextField(

                controller:
                confirmPasswordController,

                obscureText: true,

                style: const TextStyle(
                    color: Colors.white),

                decoration: InputDecoration(

                  hintText:
                  "Konfirmasi Password",

                  hintStyle:
                  const TextStyle(
                    color: Colors.grey,
                  ),

                  filled: true,

                  fillColor:
                  Colors.grey.shade900,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                        12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // BUTTON REGISTER
              SizedBox(

                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.red,
                  ),

                  onPressed:
                  isLoading
                      ? null
                      : register,

                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}