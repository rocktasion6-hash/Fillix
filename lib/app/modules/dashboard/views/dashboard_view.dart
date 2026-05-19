import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../data/models/film_model.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants.dart'; // Import constant

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = AppColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                color: AppColors.textGrey,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : PageView.builder(
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
                                    Positioned.fill(
                                      child: Image.network(
                                        film.gambarSampul?.trim().isNotEmpty ==
                                                true
                                            ? film.gambarSampul!
                                            : (film.gambarPoster ?? ''),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                        errorBuilder: (c, e, s) =>
                                            Container(color: AppColors.surface),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.7),
                                              Colors.transparent,
                                              Colors.transparent,
                                              bgColor,
                                              bgColor,
                                            ],
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
                                    Positioned(
                                      bottom: -2,
                                      left: 0,
                                      right: 0,
                                      height: 4,
                                      child: Container(color: bgColor),
                                    ),
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
                                              color: AppColors.textGrey,
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
                                              color: AppColors.textWhite,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.accent
                                                      .withOpacity(0.4),
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
                        color: AppColors.textWhite,
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
                                          color: AppColors.surface,
                                          child: Icon(
                                            Icons.broken_image,
                                            color: AppColors.textGrey,
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
                                      color: AppColors.textWhite,
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
                        color: AppColors.textWhite,
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
                    SizedBox(height: 40),
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
                color: AppColors.textWhite,
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
        color: AppColors.surface,
        child: Center(
          child: Icon(Icons.movie, size: 48, color: AppColors.textGrey),
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
          color: AppColors.surface,
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: 48,
              color: AppColors.textGrey,
            ),
          ),
        );
      },
    );
  }
}