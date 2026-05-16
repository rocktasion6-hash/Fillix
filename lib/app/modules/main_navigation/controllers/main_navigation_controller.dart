import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  // Index untuk mengontrol tab mana yang sedang aktif
  var currentIndex = 0.obs;

  // Variabel untuk menyimpan role user yang login
  String role = 'user';

  @override
  void onInit() {
    super.onInit();
    // Tangkap arguments role dari halaman Login
    if (Get.arguments != null) {
      role = Get.arguments as String;
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
