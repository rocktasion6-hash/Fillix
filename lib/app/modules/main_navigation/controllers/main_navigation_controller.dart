import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;

  String role = 'user';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      role = Get.arguments as String;
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
