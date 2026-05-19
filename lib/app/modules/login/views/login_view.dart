import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/widgets/logo_fillix.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBrown = Color(0xFF443127);
    const Color softBrown = Color(0xFF5A4032);
    const Color accentYellow = Color(0xFFFBE488);
    const Color cream = Color(0xFFFFF8E7);

    return Scaffold(
      backgroundColor: primaryBrown,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBrown,
                    softBrown,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoFillix(fontSize: 28),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                    child: const Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: accentYellow,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Hello!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Login untuk melanjutkan menonton film favoritmu di Fillix Movies.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // ================= FORM CARD =================
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(28, 30, 28, 20),
                decoration: const BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          color: primaryBrown,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Masukkan email dan password kamu",
                        style: TextStyle(
                          color: Colors.brown.withOpacity(0.55),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Email
                      _inputField(
                        controller: controller.emailController,
                        hintText: "Email",
                        icon: Icons.email_outlined,
                        primaryBrown: primaryBrown,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 18),

                      // Password
                      Obx(
                        () => _inputField(
                          controller: controller.passwordController,
                          hintText: "Password",
                          icon: Icons.lock_outline,
                          primaryBrown: primaryBrown,
                          obscureText: !controller.isPasswordVisible.value,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isPasswordVisible.toggle();
                            },
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: primaryBrown.withOpacity(0.65),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Obx(
                          () => controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryBrown,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: controller.login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBrown,
                                    elevation: 8,
                                    shadowColor:
                                        primaryBrown.withOpacity(0.35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: accentYellow,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum punya akun? ",
                            style: TextStyle(
                              color: Colors.brown.withOpacity(0.55),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.REGISTER),
                            child: const Text(
                              "Daftar",
                              style: TextStyle(
                                color: primaryBrown,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color primaryBrown,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: primaryBrown.withOpacity(0.7),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 18,
          ),
        ),
      ),
    );
  }
}