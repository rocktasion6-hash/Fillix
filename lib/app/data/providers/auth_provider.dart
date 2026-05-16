import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends GetxService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Registrasi User
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  // 2. Login User
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  // 3. Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // 4. Ambil Role Pengguna (DIPERBARUI)
  Future<String> getUserRole(String userId) async {
    try {
      // Menggunakan maybeSingle agar tidak throw exception jika data belum masuk ke profiles
      final data = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .maybeSingle(); 

      if (data != null) {
        return data['role'] as String;
      }
      return 'user';
    } catch (e) {
      print("Error fetching role: $e");
      return 'user';
    }
  }

  // 5. Cek apakah ada session yang aktif
  Session? get currentSession => _supabase.auth.currentSession;
  
  // Ambil ID user yang sedang login saat ini
  String? get currentUserId => _supabase.auth.currentUser?.id;
}