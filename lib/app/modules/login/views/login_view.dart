import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/widgets/logo_fillix.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna sesuai permintaan (Coklat tua dan Kuning pastel)
    const Color primaryBrown = Color(0xFF443127); 
    const Color accentYellow = Color(0xFFFBE488);

    return Scaffold(
      backgroundColor: primaryBrown,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogoFillix(fontSize: 28),
                  SizedBox(height: 30),
                  Text(
                    "Hello!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Welcome back to Fillix Movies",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            // White Card Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          color: primaryBrown,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      
                      // Email Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(Icons.email_outlined, color: primaryBrown.withOpacity(0.7)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Obx(() => TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(Icons.lock_outline, color: primaryBrown.withOpacity(0.7)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value 
                                  ? Icons.visibility 
                                  : Icons.visibility_off,
                                color: primaryBrown.withOpacity(0.7),
                              ),
                              onPressed: () => controller.isPasswordVisible.toggle(),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                          ),
                        )),
                      ),
                      SizedBox(height: 15),
                      
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Obx(() => controller.isLoading.value 
                          ? Center(child: CircularProgressIndicator(color: primaryBrown))
                          : ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBrown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                                shadowColor: primaryBrown.withOpacity(0.5),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: accentYellow,
                                ),
                              ),
                            )),
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Or login with
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Or login with", style: TextStyle(color: Colors.grey[500])),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                        ],
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Social Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(Icons.facebook, Colors.blue[700]!),
                          SizedBox(width: 20),
                          _socialButton(Icons.g_mobiledata_rounded, Colors.red[600]!, size: 36),
                          SizedBox(width: 20),
                          _socialButton(Icons.apple, Colors.black),
                        ],
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have account? ", style: TextStyle(color: Colors.grey[600])),
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.REGISTER),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: primaryBrown,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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

  Widget _socialButton(IconData icon, Color color, {double size = 26}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}
