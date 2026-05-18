import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constants.dart'; // Import constant

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Daftar Film",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, color: AppColors.textWhite),
            onPressed: () => Get.offAllNamed(Routes.LOGIN),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              onChanged: controller.searchFilm,
              style: TextStyle(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: 'Cari film atau kategori...',
                hintStyle: TextStyle(color: AppColors.textGrey),
                prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (controller.filteredFilm.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.value.isEmpty
                        ? 'Belum ada data film'
                        : 'Film tidak ditemukan',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.filteredFilm.length,
                itemBuilder: (context, index) {
                  final film = controller.filteredFilm[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    color: AppColors.surface,
                    child: InkWell(
                      onTap: () =>
                          Get.toNamed(Routes.DETAIL_FILM, arguments: film),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              film.gambarPoster ?? "",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: AppColors.surface,
                                    child: Icon(
                                      Icons.broken_image,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.9),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  film.judul ?? "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  film.kategori ?? "",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (controller.isAdmin.value)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black.withOpacity(
                                      0.6,
                                    ),
                                    radius: 16,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.blue[300],
                                      ),
                                      onPressed: () => Get.toNamed(
                                        Routes.ADMIN_CRUD,
                                        arguments: film,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  CircleAvatar(
                                    backgroundColor: Colors.black.withOpacity(
                                      0.6,
                                    ),
                                    radius: 16,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 16,
                                        color: Colors.red[300],
                                      ),
                                      onPressed: () =>
                                          _confirmDelete(film.id!, film.judul!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(
        () => controller.isAdmin.value
            ? FloatingActionButton.extended(
                onPressed: () => Get.toNamed(Routes.ADMIN_CRUD),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                label: Text("Tambah"),
                icon: Icon(Icons.add),
              )
            : SizedBox(),
      ),
    );
  }

  void _confirmDelete(String id, String judul) {
    Get.defaultDialog(
      title: "Hapus Film",
      titleStyle: TextStyle(color: Colors.black),
      middleText: "Yakin ingin menghapus '$judul'?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      backgroundColor: Colors.white,
      onConfirm: () {
        controller.deleteFilm(id);
        Get.back();
      },
    );
  }
}
