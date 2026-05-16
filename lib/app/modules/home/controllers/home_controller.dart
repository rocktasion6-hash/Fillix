import 'package:get/get.dart';
import '../../../data/models/film_model.dart';
import '../../../data/providers/film_provider.dart';

class HomeController extends GetxController {
  final FilmProvider _filmProvider = Get.find<FilmProvider>();

  // State Management
  var listFilm = <FilmModel>[].obs;
  var isLoading = true.obs;
  var isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("Argument yang diterima: ${Get.arguments}");
    // Mengambil role yang dikirim dari halaman Login melalui arguments
    if (Get.arguments != null) {
      isAdmin.value = (Get.arguments == 'admin');
      print("Status isAdmin: ${isAdmin.value}");
    }
    fetchFilms();
  }

  void fetchFilms() async {
    try {
      isLoading.value = true;
      var result = await _filmProvider.getAllFilms();
      listFilm.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void deleteFilm(String id) async {
    try {
      await _filmProvider.deleteFilm(id);
      Get.snackbar("Sukses", "Film berhasil dihapus");
      fetchFilms(); // Refresh data
    } catch (e) {
      Get.snackbar("Gagal", e.toString());
    }
  }
}
