import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../data/models/film_model.dart';
import '../../../routes/app_routes.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna dasar aplikasi Anda
    final Color bgColor = Colors.grey[100]!;

    return Scaffold(
      backgroundColor: bgColor,
      // 1. Kunci Utama: Tarik body ke belakang AppBar agar full-bleed
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        // 2. AppBar dibuat transparan
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          // 3. Padding dihapus dari sini agar gambar bisa mentok ke ujung layar
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BAGIAN HERO (Rekomendasi yang Menyatu dengan Background) ---
              Builder(
                builder: (context) {
                  final featuredHeight =
                      MediaQuery.of(context).size.height * 0.55;
                  return SizedBox(
                    height: featuredHeight,
                    child: controller.featuredFilms.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada rekomendasi saat ini',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          )
                        : PageView.builder(
                            // viewportFraction diubah ke 1.0 agar melebar penuh
                            controller: PageController(viewportFraction: 1.0),
                            itemCount: controller.featuredFilms.length,
                            itemBuilder: (context, index) {
                              final film = controller.featuredFilms[index];
                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                  Routes.DETAIL_FILM,
                                  arguments: film,
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Layer 1: Gambar Sampul (Full Width & Height)
                                    Positioned.fill(
                                      child: Image.network(
                                        film.gambarSampul?.trim().isNotEmpty ==
                                                true
                                            ? film.gambarSampul!
                                            : (film.gambarPoster ?? ''),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                        errorBuilder: (c, e, s) =>
                                            Container(color: Colors.grey[300]),
                                      ),
                                    ),

                                    // Layer 2: Gradient menyatu ke warna background
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(
                                                0.6,
                                              ), // Gelap di atas agar "Dashboard" terbaca
                                              Colors
                                                  .transparent, // Bening di tengah memperlihatkan gambar
                                              Colors.transparent,
                                              bgColor, // Diubah jadi solid lebih awal
                                              bgColor, // Jaga tetap solid sampai bawah
                                            ],
                                            // Memajukan titik solid menjadi 95% agar transisi selesai sebelum gambar terpotong
                                            stops: const [
                                              0.0,
                                              0.2,
                                              0.5,
                                              0.95,
                                              1.0,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Layer Tambahan: Penutup Jahitan (Anti-aliasing bleed cover)
                                    Positioned(
                                      bottom: -2,
                                      left: 0,
                                      right: 0,
                                      height: 4,
                                      child: Container(color: bgColor),
                                    ),

                                    // Layer 3: Tombol Play & Teks (Dibuat di tengah ala Netflix)
                                    Positioned(
                                      left: 20,
                                      right: 20,
                                      bottom: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            film.kategori?.toUpperCase() ??
                                                'REKOMENDASI',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            film.judul ??
                                                'Film terbaik untukmu',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 16),

                                          // Floating Play Button
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFBE488),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(
                                                    0xFFFBE488,
                                                  ).withOpacity(0.4),
                                                  blurRadius: 15,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              size: 36,
                                              color: Color(0xFF443127),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  );
                },
              ),

              // --- KONTEN BAWAH ("Terbaru" dan "Rekomendasi") ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      'Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.latest.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final film = controller.latest[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(
                              Routes.DETAIL_FILM,
                              arguments: film,
                            ),
                            child: SizedBox(
                              width: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        film.gambarPoster ?? '',
                                        width: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    film.judul ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 24),
                    Text(
                      'Rekomendasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.recommended.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final film = controller.recommended[index];
                          return _buildFilmCard(film);
                        },
                      ),
                    ),
                    SizedBox(height: 40), // Jarak aman di bagian paling bawah
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilmCard(FilmModel film) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL_FILM, arguments: film),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImageLayer(film),
              ),
            ),
            SizedBox(height: 8),
            Text(
              film.judul ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLayer(FilmModel film) {
    final imageUrl = film.gambarPoster?.trim().isNotEmpty == true
        ? film.gambarPoster!
        : film.gambarSampul?.trim().isNotEmpty == true
        ? film.gambarSampul!
        : null;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.movie, size: 48, color: Colors.grey[600]),
        ),
      );
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Icon(Icons.broken_image, size: 48, color: Colors.grey[600]),
          ),
        );
      },
    );
  }
}
