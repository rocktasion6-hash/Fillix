import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> login() async {

    try {

      setState(() {
        isLoading = true;
      });

      await Supabase.instance.client.auth
          .signInWithPassword(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      Get.offAll(
              () => const HomePage());

    } on AuthException catch (e) {

      Get.snackbar(
        "Login Gagal",
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

      body: Center(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.movie,
                color: Colors.red,
                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(
                "Fillix",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
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

              const SizedBox(height: 30),

              // BUTTON LOGIN
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
                      : login,

                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  const Text(
                    "Belum punya akun? ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  GestureDetector(

                    onTap: () {

                      Get.to(() =>
                      const RegisterPage());
                    },

                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}