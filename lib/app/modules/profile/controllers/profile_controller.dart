import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  final name = ''.obs;
  final email = ''.obs;
  final role = ''.obs;
  final isLoading = false.obs;

  // RxList tambahan untuk menampung data riwayat tiket dari Supabase
  RxList<dynamic> tiketList = <dynamic>[].obs;
  RxBool isLoadingTiket = false.obs;

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

      // Ambil data profil
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      name.value = data?['name'] ?? user.email?.split('@').first ?? 'User';
      role.value = data?['role'] ?? 'User';

      // Setelah profil berhasil diambil, otomatis muat riwayat tiketnya
      await fetchRiwayatTiket(user.id);
    } catch (e) {
      name.value = 'User';
      email.value = supabase.auth.currentUser?.email ?? 'Tidak ada email';
      role.value = 'User';
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi mengambil riwayat tiket berdasarkan user_id dari tabel di Supabase
  Future<void> fetchRiwayatTiket(String userId) async {
    try {
      isLoadingTiket.value = true;
      
      // Mengambil data dari tabel tiket (sesuaikan nama tabel jika berbeda, misal: 'tickets' atau 'tiket')
      final response = await supabase
          .from('tiket') 
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false); // Mengurutkan dari pemesanan terbaru

      if (response != null) {
        tiketList.assignAll(response);
      }
    } catch (e) {
      print('Error fetch tiket: $e');
    } finally {
      isLoadingTiket.value = false;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed('/login');
  }
}