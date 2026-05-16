import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/film_model.dart';

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
    // Ambil data film yang dikirim melalui arguments
    final FilmModel film = Get.arguments;
    
    // Tema warna Fillix eksklusif
    const Color primaryBrown = Color(0xFF443127);
    const Color accentYellow = Color(0xFFFBE488);

    return Scaffold(
      backgroundColor: primaryBrown,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image & Play Button
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Gambar Poster/Sampul melengkung di bawah
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(film.gambarSampul ?? film.gambarPoster ?? ""),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                
                // Gradient hitam tipis di atas agar tombol back & status bar tetap terbaca
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

                // Back Button (Kiri Atas)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),

                // Play Button (Tengah Bawah melayang)
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
                        child: Icon(Icons.play_arrow_rounded, size: 40, color: primaryBrown),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Jarak untuk tombol play yang melayang
            SizedBox(height: 60), 

            // Informasi Film
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tanggal Rilis
                  Text(
                    "Release Date: ${film.tanggalRilis ?? '-'}",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  // Judul Film
                  Text(
                    film.judul ?? "Unknown Title",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Kategori/Tags (Berbentuk Kapsul/Pill)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildChip(film.kategori ?? "Movie", accentYellow, primaryBrown, true),
                      _buildChip("Fillix Movie", Colors.white.withOpacity(0.1), Colors.white, false),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Rating Row
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: accentYellow, size: 30),
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
                  Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
                  SizedBox(height: 25),

                  // Synopsis
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
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk membuat label kategori (Kapsul)
  Widget _buildChip(String label, Color bgColor, Color textColor, bool isPrimary) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? Colors.transparent : Colors.white.withOpacity(0.2),
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