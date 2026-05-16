import 'dart:io';
import 'package:get/get.dart';
import '../../../data/providers/film_provider.dart';
import '../../../data/models/film_model.dart';

class DashboardController extends GetxController {
  final FilmProvider _filmProvider = Get.find<FilmProvider>();

  var featuredFilm = Rxn<FilmModel>();
  var recommended = <FilmModel>[].obs;
  var latest = <FilmModel>[].obs;
  var isLoading = true.obs;

  List<FilmModel> get featuredFilms => recommended.where(_hasImage).toList();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<bool> _isImageReachable(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return false;
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);
      final req = await client.openUrl('HEAD', uri);
      final resp = await req.close();
      client.close(force: true);
      return resp.statusCode >= 200 && resp.statusCode < 400;
    } catch (_) {
      return false;
    }
  }

  void fetchData() async {
    try {
      isLoading.value = true;
      final films = await _filmProvider.getAllFilms();

      // Latest: sort by tanggalRilis desc
      final byDate = List<FilmModel>.from(films);
      byDate.sort((a, b) => (b.tanggalRilis ?? 0).compareTo(a.tanggalRilis ?? 0));

      // Prefer films that have image fields and reachable URLs
      final latestCandidates = <FilmModel>[];
      for (final f in byDate) {
        if (_hasImage(f)) {
          final url = f.gambarSampul?.trim().isNotEmpty == true ? f.gambarSampul! : (f.gambarPoster ?? '');
          if (url.isNotEmpty && await _isImageReachable(url)) {
            latestCandidates.add(f);
          }
        }
        if (latestCandidates.length >= 6) break;
      }
      if (latestCandidates.length >= 6) {
        latest.assignAll(latestCandidates.take(6).toList());
      } else {
        latest.assignAll(byDate.take(6).toList());
      }

      // Recommended: top by skorRating desc, prefer reachable images
      final byRating = List<FilmModel>.from(films);
      byRating.sort((a, b) => (b.skorRating ?? 0).compareTo(a.skorRating ?? 0));

      final recommendedCandidates = <FilmModel>[];
      for (final f in byRating) {
        if (_hasImage(f)) {
          final url = f.gambarSampul?.trim().isNotEmpty == true ? f.gambarSampul! : (f.gambarPoster ?? '');
          if (url.isNotEmpty && await _isImageReachable(url)) {
            recommendedCandidates.add(f);
          }
        }
        if (recommendedCandidates.length >= 6) break;
      }
      if (recommendedCandidates.isNotEmpty) {
        recommended.assignAll(recommendedCandidates.take(6).toList());
      } else {
        recommended.assignAll(byRating.take(6).toList());
      }

      // Featured: highest rated that has reachable image
      FilmModel? featured;
      for (final f in byRating) {
        if (_hasImage(f)) {
          final url = f.gambarSampul?.trim().isNotEmpty == true ? f.gambarSampul! : (f.gambarPoster ?? '');
          if (url.isNotEmpty && await _isImageReachable(url)) {
            featured = f;
            break;
          }
        }
      }
      featuredFilm.value = featured ?? (byRating.isNotEmpty ? byRating.first : null);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasImage(FilmModel film) {
    return (film.gambarPoster?.trim().isNotEmpty == true) || (film.gambarSampul?.trim().isNotEmpty == true);
  }
}
