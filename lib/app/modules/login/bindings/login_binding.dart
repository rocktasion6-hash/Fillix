import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../data/providers/auth_provider.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Inisialisasi Provider dan Controller
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}