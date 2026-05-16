import 'dart:ui';
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
      body: Stack(
        children: [
          // Lapis 1: Konten yang bisa di-scroll
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image & Play Button
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Solusi 2: Gradient Fading (Gaya Netflix)
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.55, // Diperpanjang sedikit agar gradasi lebih halus
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Layer 1: Gambar Asli
                          Image.network(
                            film.gambarSampul ?? film.gambarPoster ?? "",
                            fit: BoxFit.cover, // Cover dengan fokus di atas
                            alignment: Alignment.topCenter,
                          ),
                          
                          // Layer 2: Efek Gradient Fading menyatu ke Coklat Tua
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,                // Atas murni bening
                                  Colors.transparent,                // Tengah bening
                                  primaryBrown.withOpacity(0.8),     // Memudar lumayan tebal
                                  primaryBrown,                      // Bawah coklat solid
                                ],
                                stops: const [0.0, 0.5, 0.85, 1.0], // Transisi dipercepat di bawah
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Penutup "Garis Jahitan" (Anti-aliasing bleed cover) 
                    Positioned(
                      bottom: -2,
                      left: 0,
                      right: 0,
                      height: 4,
                      child: Container(
                        color: primaryBrown,
                      ),
                    ),
                    
                    // Gradient hitam tipis di atas agar tombol & status bar tetap terbaca saat belum discroll
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
                      SizedBox(height: 15),
                      
                      // Row: Poster Kecil & Judul Film (Membawa kembali layout lama)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster Kecil
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
                          
                          // Judul Film di sebelah poster
                          Expanded(
                            child: Text(
                              film.judul ?? "Unknown Title",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26, // Disesuaikan agar muat
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

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
          
          // Lapis 2: Tombol Kembali Melayang (Statis / Tidak bergerak saat discroll)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20, // Dipindahkan ke kanan atas sesuai instruksi
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                // Karena letaknya di kanan atas, icon 'Close' terasa lebih natural dari UI/UX 
                // dibanding panah kiri, tapi tetap menjalankan fungsi kembali (Get.back)
                child: Icon(Icons.close_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
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