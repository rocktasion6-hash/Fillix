import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailerView {
  static Future<void> open(String? url) async {
    if (url == null || url.isEmpty) {
      Get.snackbar('Info', 'Trailer tidak tersedia untuk film ini.');
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Error', 'Tidak dapat membuka trailer.');
    }
  }
}
