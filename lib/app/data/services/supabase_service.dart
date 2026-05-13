import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../supabase_config.dart';

class SupabaseService extends GetxService {
  // Fungsi inisialisasi yang akan dipanggil di main.dart
  Future<SupabaseService> init() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    return this;
  }

  // Getter untuk mempermudah akses client Supabase di mana saja
  SupabaseClient get client => Supabase.instance.client;
}