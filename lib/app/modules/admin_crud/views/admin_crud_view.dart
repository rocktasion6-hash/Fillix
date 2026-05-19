import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_crud_controller.dart';

class AdminCrudView extends GetView<AdminCrudController> {
  const AdminCrudView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBrown = Color(0xFF443127);
    const Color softBrown = Color(0xFF5A4032);
    const Color accentYellow = Color(0xFFFBE488);
    const Color cream = Color(0xFFFFF8E7);

    return Scaffold(
      backgroundColor: primaryBrown,
      appBar: AppBar(
        backgroundColor: primaryBrown,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Obx(
          () => Text(
            controller.isEdit.value ? "Edit Film" : "Tambah Film",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryBrown,
                  softBrown,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isEdit.value
                        ? "Perbarui Data Film"
                        : "Tambahkan Film Baru",
                    style: const TextStyle(
                      color: accentYellow,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.isEdit.value
                        ? "Ubah informasi film yang sudah tersimpan."
                        : "Isi data film sesuai informasi dari API Fillix.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              decoration: const BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Informasi Film", primaryBrown),

                    const SizedBox(height: 14),

                    _inputField(
                      controller: controller.judulController,
                      label: "Judul Film",
                      hint: "Contoh: Cars",
                      icon: Icons.movie_creation_outlined,
                      primaryBrown: primaryBrown,
                    ),

                    const SizedBox(height: 16),

                    _inputField(
                      controller: controller.kategoriController,
                      label: "Kategori / Genre",
                      hint: "Contoh: Animasi",
                      icon: Icons.category_outlined,
                      primaryBrown: primaryBrown,
                    ),

                    const SizedBox(height: 16),

                    _inputField(
                      controller: controller.ringkasanController,
                      label: "Ringkasan",
                      hint: "Masukkan sinopsis singkat film",
                      icon: Icons.description_outlined,
                      primaryBrown: primaryBrown,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle("Media Film", primaryBrown),

                    const SizedBox(height: 14),

                    _inputField(
                      controller: controller.posterController,
                      label: "URL Gambar Poster",
                      hint: "Masukkan URL poster dari Cloudinary",
                      icon: Icons.image_outlined,
                      primaryBrown: primaryBrown,
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: 16),

                    _inputField(
                      controller: controller.sampulController,
                      label: "URL Gambar Sampul",
                      hint: "Masukkan URL sampul dari Cloudinary",
                      icon: Icons.wallpaper_outlined,
                      primaryBrown: primaryBrown,
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: 16),

                    _inputField(
                      controller: controller.trailerController,
                      label: "URL Trailer",
                      hint: "Masukkan URL trailer YouTube",
                      icon: Icons.play_circle_outline_rounded,
                      primaryBrown: primaryBrown,
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle("Detail Tambahan", primaryBrown),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            controller: controller.ratingController,
                            label: "Skor Rating",
                            hint: "98",
                            icon: Icons.star_outline_rounded,
                            primaryBrown: primaryBrown,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _inputField(
                            controller: controller.rilisController,
                            label: "Tanggal Rilis",
                            hint: "9062006",
                            icon: Icons.date_range_outlined,
                            primaryBrown: primaryBrown,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Obx(
                      () => controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryBrown,
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: controller.saveFilm,
                                icon: Icon(
                                  controller.isEdit.value
                                      ? Icons.update_rounded
                                      : Icons.save_rounded,
                                  color: primaryBrown,
                                ),
                                label: Text(
                                  controller.isEdit.value
                                      ? "Update Film"
                                      : "Simpan Film",
                                  style: const TextStyle(
                                    color: primaryBrown,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentYellow,
                                  elevation: 6,
                                  shadowColor: primaryBrown.withOpacity(0.25),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color primaryBrown) {
    return Text(
      title,
      style: TextStyle(
        color: primaryBrown,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color primaryBrown,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: primaryBrown.withOpacity(0.75),
            fontWeight: FontWeight.w600,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              bottom: maxLines > 1 ? 70 : 0,
            ),
            child: Icon(
              icon,
              color: primaryBrown.withOpacity(0.7),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}