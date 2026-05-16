import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../data/providers/auth_provider.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthProvider>(() => AuthProvider());
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}