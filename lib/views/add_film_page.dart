import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/film_controller.dart';
import '../models/film_model.dart';

class AddFilmPage extends StatelessWidget {
  AddFilmPage({super.key});

  final FilmController controller =
      Get.find<FilmController>();

  final judulController =
      TextEditingController();

  final ringkasanController =
      TextEditingController();

  final gambarPosterController =
      TextEditingController();

  final gambarSampulController =
      TextEditingController();

  final tanggalRilisController =
      TextEditingController();

  final skorRatingController =
      TextEditingController();

  final kategoriController =
      TextEditingController();

  final trailerController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: const Text(
          "Tambah Film",
        ),

        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            // JUDUL
            buildTextField(
              controller: judulController,
              hint: "Judul Film",
            ),

            const SizedBox(height: 15),

            // RINGKASAN
            buildTextField(
              controller:
              ringkasanController,
              hint: "Ringkasan",
              maxLines: 4,
            ),

            const SizedBox(height: 15),

            // GAMBAR POSTER
            buildTextField(
              controller:
              gambarPosterController,
              hint: "URL Gambar Poster",
            ),

            const SizedBox(height: 15),

            // GAMBAR SAMPUL
            buildTextField(
              controller:
              gambarSampulController,
              hint: "URL Gambar Sampul",
            ),

            const SizedBox(height: 15),

            // TANGGAL RILIS
            buildTextField(
              controller:
              tanggalRilisController,
              hint: "Tanggal Rilis",
              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            // SKOR RATING
            buildTextField(
              controller:
              skorRatingController,
              hint: "Skor Rating",
              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            // KATEGORI
            buildTextField(
              controller:
              kategoriController,
              hint: "Kategori",
            ),

            const SizedBox(height: 15),

            // TRAILER
            buildTextField(
              controller:
              trailerController,
              hint: "URL Trailer",
            ),

            const SizedBox(height: 30),

            // BUTTON SIMPAN
            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.red,
                ),

                onPressed: () async {

                  Film film = Film(

                    id: "",

                    judul:
                    judulController.text,

                    ringkasan:
                    ringkasanController.text,

                    gambarPoster:
                    gambarPosterController.text,

                    gambarSampul:
                    gambarSampulController.text,

                    tanggalRilis:
                    int.parse(
                      tanggalRilisController.text,
                    ),

                    skorRating:
                    int.parse(
                      skorRatingController.text,
                    ),

                    kategori:
                    kategoriController.text,

                    urlTrailer:
                    trailerController.text,
                  );

                  await controller
                      .createFilm(film);

                  Get.back();
                },

                child: const Text(

                  "Simpan Film",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // WIDGET TEXTFIELD
  // =========================
  Widget buildTextField({

    required TextEditingController
    controller,

    required String hint,

    int maxLines = 1,

    TextInputType keyboardType =
        TextInputType.text,
  }) {

    return TextField(

      controller: controller,

      maxLines: maxLines,

      keyboardType: keyboardType,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.grey,
        ),

        filled: true,

        fillColor: Colors.grey.shade900,

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
    );
  }
}