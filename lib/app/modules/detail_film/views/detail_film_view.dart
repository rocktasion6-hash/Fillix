import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/detail_film_controller.dart';

class DetailFilmView extends StatelessWidget {
  const DetailFilmView({super.key});

  Future<void> _launchTrailer(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      Get.snackbar(
        "Info",
        "Trailer tidak tersedia untuk film ini.",
        backgroundColor: Colors.white,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(20),
      );
      return;
    }

    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        "Error",
        "Tidak dapat membuka link trailer.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailFilmController>();
    final film = controller.film;

    const Color primaryBrown = Color(0xFF443127);
    const Color accentYellow = Color(0xFFFBE488);

    return Scaffold(
      backgroundColor: primaryBrown,
      body: Stack(
        children: [
          // Konten yang bisa di-scroll
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image & Play Button
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            film.gambarSampul ?? film.gambarPoster ?? "",
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  primaryBrown.withOpacity(0.8),
                                  primaryBrown,
                                ],
                                stops: const [0.0, 0.5, 0.85, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: -2,
                      left: 0,
                      right: 0,
                      height: 4,
                      child: Container(color: primaryBrown),
                    ),

                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Play Button melayang
                    Positioned(
                      bottom: -35,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _launchTrailer(film.urlTrailer),
                          child: Container(
                            padding: EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: accentYellow,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentYellow.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(Icons.play_arrow_rounded,
                                size: 40, color: primaryBrown),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 60),

                // Informasi Film
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Release Date: ${film.tanggalRilis ?? '-'}",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 15),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              film.gambarPoster ?? "",
                              width: 100,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              film.judul ?? "Unknown Title",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildChip(film.kategori ?? "Movie", accentYellow,
                              primaryBrown, true),
                          _buildChip("Fillix Movie",
                              Colors.white.withOpacity(0.1), Colors.white, false),
                        ],
                      ),
                      SizedBox(height: 30),

                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: accentYellow, size: 30),
                          SizedBox(width: 8),
                          Text(
                            "${film.skorRating ?? 0}/100",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Fillix Score",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 25),
                      Divider(
                          color: Colors.white.withOpacity(0.1), thickness: 1),
                      SizedBox(height: 25),

                      Text(
                        "Synopsis",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        film.ringkasan ?? "No synopsis available for this movie.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 16,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 30),

                      // Tombol Pesan Tiket
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: controller.navigateToPesanTiket,
                          icon: const Icon(Icons.confirmation_number),
                          label: const Text('Pesan Tiket',
                              style: TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentYellow,
                            foregroundColor: primaryBrown,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
                      Divider(
                          color: Colors.white.withOpacity(0.1), thickness: 1),
                      SizedBox(height: 20),

                      // Section Komentar
                      Text(
                        "Komentar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),

                      // Input Komentar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.komentarController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Tulis komentar...',
                                hintStyle:
                                    TextStyle(color: Colors.white54),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: accentYellow),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: controller.kirimKomentar,
                            icon: Icon(Icons.send, color: accentYellow),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // List Komentar
                      Obx(() {
                        if (controller.isLoadingKomentar.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (controller.komentarList.isEmpty) {
                          return Text('Belum ada komentar.',
                              style: TextStyle(color: Colors.white54));
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.komentarList.length,
                          separatorBuilder: (_, __) => Divider(
                              color: Colors.white.withOpacity(0.1)),
                          itemBuilder: (_, i) {
                            final k = controller.komentarList[i];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor:
                                    accentYellow.withOpacity(0.2),
                                child: Icon(Icons.person,
                                    color: accentYellow),
                              ),
                              title: Text(k.namaUser ?? 'Anonim',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              subtitle: Text(k.isi ?? '',
                                  style: TextStyle(
                                      color: Colors.white70)),
                            );
                          },
                        );
                      }),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tombol Kembali Melayang
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(Icons.close_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color bgColor, Color textColor,
      bool isPrimary) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary
              ? Colors.transparent
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
