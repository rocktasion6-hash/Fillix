import 'package:fillix/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/views/home_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../profile/views/profile_view.dart';
import '../../profile/controllers/profile_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack digunakan agar state (misal posisi scroll) di tiap halaman tidak hilang
      // saat kita berpindah-pindah tab.
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          // Tab 0: Dashboard
          DashboardView(),

          // Tab 1: HomeView (List Film)
          // HomeView harus diakses di sini
          HomeView(),

          // Tab 2: Profile (Kosong sementara)
          ProfileView()
        ],
      )),

      // Navbar Bawah yang elegan
      bottomNavigationBar: Obx(() => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red[700], // Warna merah ala Fillix
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // Mencegah animasi aneh jika tab > 3
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter_rounded),
              label: "List Film",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Profile",
            ),
          ],
        ),
      )),
    );
  }
}
