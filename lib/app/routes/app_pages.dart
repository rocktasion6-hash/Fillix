import 'package:get/get.dart';

// Import semua binding dan view yang sudah dibuat
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/admin_crud/bindings/admin_crud_binding.dart';
import '../modules/admin_crud/views/admin_crud_view.dart';
import '../modules/detail_film/views/detail_film_view.dart';
import '../modules/detail_film/bindings/detail_film_binding.dart';
import '../modules/detail_film/bindings/detail_film_binding.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';
import 'app_routes.dart';

class AppPages {
  // Tentukan halaman pertama yang muncul saat aplikasi dibuka
  static const INITIAL = Routes.LOGIN;

  static final routes = [
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
    )
  ];
}