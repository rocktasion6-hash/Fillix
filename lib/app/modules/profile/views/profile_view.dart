import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';


class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  static const Color darkBrown = Color(0xFF443127);
  static const Color softBrown = Color(0xFF5A4032);
  static const Color lightBrown = Color(0xFF7A5A46);
  static const Color accentYellow = Color(0xFFFBE488);
  static const Color softYellow = Color(0xFFFFF2B8);
  static const Color cream = Color(0xFFFFF8E7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBrown,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: accentYellow,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: softBrown,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 105,
                        height: 105,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentYellow,
                              softYellow,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentYellow.withOpacity(0.28),
                              blurRadius: 35,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: darkBrown,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        controller.name.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: cream,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        controller.email.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: cream.withOpacity(0.75),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: accentYellow.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: accentYellow.withOpacity(0.45),
                          ),
                        ),
                        child: Text(
                          controller.role.value.toUpperCase(),
                          style: const TextStyle(
                            color: accentYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _MenuCard(
                  icon: Icons.account_circle_rounded,
                  title: 'Akun Saya',
                  subtitle: 'Informasi akun pengguna',
                  onTap: () {},
                ),

                _MenuCard(
                  icon: Icons.confirmation_number_rounded,
                  title: 'Tiket Saya',
                  subtitle: 'Lihat riwayat tiket film',
                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Fitur tiket saya belum tersedia',
                      backgroundColor: accentYellow,
                      colorText: darkBrown,
                    );
                  },
                ),

                _MenuCard(
                  icon: Icons.lock_rounded,
                  title: 'Keamanan',
                  subtitle: 'Kelola keamanan akun',
                  onTap: () {},
                ),

                _MenuCard(
                  icon: Icons.info_rounded,
                  title: 'Tentang Aplikasi',
                  subtitle: 'Fillix App versi 1.0',
                  onTap: () {},
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentYellow,
                      foregroundColor: darkBrown,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const Color darkBrown = Color(0xFF443127);
  static const Color softBrown = Color(0xFF5A4032);
  static const Color accentYellow = Color(0xFFFBE488);
  static const Color cream = Color(0xFFFFF8E7);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: softBrown.withOpacity(0.82),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentYellow.withOpacity(0.10),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: accentYellow.withOpacity(0.14),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: accentYellow,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle( 
            color: cream,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: cream.withOpacity(0.62),
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: cream.withOpacity(0.45),
        ),
      ),
    );
  }
}