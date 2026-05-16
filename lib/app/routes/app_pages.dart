import 'package:get/get.dart';

// Splash
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// Login
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

// Register
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

// Home
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// Admin CRUD
import '../modules/admin_crud/bindings/admin_crud_binding.dart';
import '../modules/admin_crud/views/admin_crud_view.dart';

// Detail Film
import '../modules/detail_film/bindings/detail_film_binding.dart';
import '../modules/detail_film/views/detail_film_view.dart';

// Pesan Tiket
import '../modules/trailer/trailer_view.dart';
import '../modules/pesan_tiket/bindings/pesan_tiket_binding.dart';
import '../modules/pesan_tiket/views/pesan_tiket_view.dart';

// Main Navigation
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';

import 'app_routes.dart';

class AppPages {
  // Halaman pertama saat aplikasi dibuka
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_CRUD,
      page: () => AdminCrudView(),
      binding: AdminCrudBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_FILM,
      page: () => DetailFilmView(),
      binding: DetailFilmBinding(),
    ),
    GetPage(
      name: Routes.MAIN_NAVIGATION,
      page: () => MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: Routes.PESAN_TIKET,
      page: () => const PesanTiketView(),
      binding: PesanTiketBinding(),
    ),
    GetPage(
      name: Routes.TRAILER,
      page: () => const TrailerView(),
    ),
  ];
}