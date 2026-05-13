import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/services/supabase_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';


void main() async {
  // 1. Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Supabase Service sebelum app berjalan
  // Ini krusial agar AuthProvider tidak error saat memanggil Supabase client
  await Get.putAsync(() => SupabaseService().init());

  runApp(
    GetMaterialApp(
      title: "Fillix App",
      debugShowCheckedModeBanner: false,
      
      // 3. Routing
      initialRoute: AppPages.INITIAL, 
      getPages: AppPages.routes,      
      
      // 4. Theme Configuration
      theme: ThemeData(
        useMaterial3: true,
        // Di Material 3, primarySwatch seringkali tidak cukup. 
        // Gunakan colorScheme untuk kontrol warna merah yang lebih kuat.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red, // Warna utama branding Fillix
        ),
        // Opsional: Atur background default menjadi gelap jika ingin gaya bioskop
        // scaffoldBackgroundColor: const Color(0xFF141414), 
      ),
      
      // Default transition antar halaman agar lebih smooth
      defaultTransition: Transition.cupertino,
    ),
  );
}