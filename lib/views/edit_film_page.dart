import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/film_controller.dart';
import '../models/film_model.dart';

class EditFilmPage extends StatelessWidget {

  final Film film;

  EditFilmPage({
    super.key,
    required this.film,
  });

  final FilmController controller =
      Get.find<FilmController>();

  late final TextEditingController
  judulController =
  TextEditingController(
    text: film.judul,
  );

  late final TextEditingController
  ringkasanController =
  TextEditingController(
    text: film.ringkasan,
  );

  late final TextEditingController
  gambarPosterController =
  TextEditingController(
    text: film.gambarPoster,
  );

  late final TextEditingController
  gambarSampulController =
  TextEditingController(
    text: film.gambarSampul,
  );

  late final TextEditingController
  tanggalRilisController =
  TextEditingController(
    text: film.tanggalRilis.toString(),
  );

  late final TextEditingController
  skorRatingController =
  TextEditingController(
    text: film.skorRating.toString(),
  );

  late final TextEditingController
  kategoriController =
  TextEditingController(
    text: film.kategori,
  );

  late final TextEditingController
  trailerController =
  TextEditingController(
    text: film.urlTrailer,
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: const Text(
          "Edit Film",
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

            // URL TRAILER
            buildTextField(
              controller:
              trailerController,
              hint: "URL Trailer",
            ),

            const SizedBox(height: 30),

            // BUTTON UPDATE
            SizedBox(

              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.blue,
                ),

                onPressed: () async {

                  Film updatedFilm = Film(

                    id: film.id,

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

                  await controller.updateFilm(
                    film.id,
                    updatedFilm,
                  );

                  Get.back();
                },

                child: const Text(

                  "Update Film",

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
  // TEXTFIELD WIDGET
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