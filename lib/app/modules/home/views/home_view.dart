import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background lembut
      appBar: AppBar(
        title: Text("Fillix Movies", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () => Get.offAllNamed(Routes.LOGIN),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (controller.listFilm.isEmpty) {
          return Center(child: Text("Belum ada data film"));
        }

        // Menggunakan GridView agar lebih menarik seperti aplikasi streaming
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            childAspectRatio: 0.65, // Rasio kartu (tinggi > lebar)
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.listFilm.length,
          itemBuilder: (context, index) {
            final film = controller.listFilm[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: InkWell(
                onTap: () => Get.toNamed(Routes.DETAIL_FILM, arguments: film),
                child: Stack(
                  children: [
                    // Gambar Poster sebagai background kartu
                    Positioned.fill(
                      child: Image.network(
                        film.gambarPoster ?? "",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                    // Overlay gradasi hitam agar teks terbaca
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          ),
                        ),
                      ),
                    ),
                    // Informasi Film
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            film.judul ?? "",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            film.kategori ?? "",
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    // Tombol Admin (Hanya muncul jika isAdmin true)
                    if (controller.isAdmin.value)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              radius: 16,
                              child: IconButton(
                                icon: Icon(Icons.edit, size: 16, color: Colors.blue),
                                onPressed: () => Get.toNamed(Routes.ADMIN_CRUD, arguments: film),
                              ),
                            ),
                            SizedBox(width: 5),
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              radius: 16,
                              child: IconButton(
                                icon: Icon(Icons.delete, size: 16, color: Colors.red),
                                onPressed: () => _confirmDelete(film.id!, film.judul!),
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
      floatingActionButton: Obx(() => controller.isAdmin.value
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(Routes.ADMIN_CRUD),
              label: Text("Tambah"),
              icon: Icon(Icons.add),
            )
          : SizedBox()),
    );
  }

  // Fungsi konfirmasi hapus agar tidak asal terhapus
  void _confirmDelete(String id, String judul) {
    Get.defaultDialog(
      title: "Hapus Film",
      middleText: "Yakin ingin menghapus '$judul'?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteFilm(id);
        Get.back();
      },
    );
  }
}