import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/admin_crud/bindings/admin_crud_binding.dart';
import '../modules/admin_crud/views/admin_crud_view.dart';

import '../modules/detail_film/bindings/detail_film_binding.dart';
import '../modules/detail_film/views/detail_film_view.dart';

import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';

import '../modules/pesan_tiket/bindings/pesan_tiket_binding.dart';
import '../modules/pesan_tiket/views/pesan_tiket_view.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.MAIN_NAVIGATION,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_CRUD,
      page: () => const AdminCrudView(),
      binding: AdminCrudBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_FILM,
      page: () => const DetailFilmView(),
      binding: DetailFilmBinding(),
    ),
    GetPage(
      name: Routes.PESAN_TIKET,
      page: () => const PesanTiketView(),
      binding: PesanTiketBinding(),
    ),
  ];
}
