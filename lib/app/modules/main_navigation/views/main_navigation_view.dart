import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/views/home_view.dart';

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
          // Tab 0: Dashboard (Kosong sementara)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.dashboard_rounded, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  "Halaman Dashboard",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                Text("Segera hadir...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          // Tab 1: HomeView (List Film)
          // HomeView harus diakses di sini
          HomeView(),

          // Tab 2: Profile (Kosong sementara)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline_rounded, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  "Halaman Profile",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                Text("Role Anda: ${controller.role}", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
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
