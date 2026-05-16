import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  final name = ''.obs;
  final email = ''.obs;
  final role = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;

      if (user == null) {
        email.value = 'Tidak ada email';
        name.value = 'Guest';
        role.value = 'User';
        return;
      }

      email.value = user.email ?? 'Tidak ada email';

      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      name.value = data?['name'] ?? user.email?.split('@').first ?? 'User';
      role.value = data?['role'] ?? 'User';
    } catch (e) {
      name.value = 'User';
      email.value = supabase.auth.currentUser?.email ?? 'Tidak ada email';
      role.value = 'User';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }
}