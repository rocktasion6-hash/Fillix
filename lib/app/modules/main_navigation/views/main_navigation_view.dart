import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/views/home_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../profile/views/profile_view.dart';
import '../../../utils/constants.dart'; // Import constant

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [DashboardView(), HomeView(), ProfileView()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.surface, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage,
            backgroundColor: AppColors.background,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: AppColors.textGrey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
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
        ),
      ),
    );
  }
}
