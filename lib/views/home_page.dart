import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/film_controller.dart';
import '../models/film_model.dart';
import 'add_film_page.dart';
import 'detail_page.dart';
import 'edit_film_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final FilmController controller =
        Get.put(FilmController());

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        title: const Text(
          "Fillix",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(

            onPressed: () async {

              await Supabase.instance.client
                  .auth.signOut();

              Get.offAll(
                      () => const LoginPage());
            },

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor: Colors.red,

        onPressed: () {

          Get.to(
                  () => AddFilmPage());
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: Obx(() {

        // LOADING
        if (controller.isLoading.value) {

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // DATA KOSONG
        if (controller.filmList.isEmpty) {

          return const Center(
            child: Text(
              "Data Film Kosong",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          );
        }

        // LIST DATA
        return ListView.builder(

          itemCount:
          controller.filmList.length,

          itemBuilder: (context, index) {

            Film film =
            controller.filmList[index];

            return Card(

              color: Colors.grey.shade900,

              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),

              child: InkWell(

                borderRadius:
                BorderRadius.circular(15),

                onTap: () {

                  Get.to(
                          () => DetailPage(
                        film: film,
                      ));
                },

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    // POSTER
                    ClipRRect(

                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),

                      child: Image.network(

                        film.gambarPoster,

                        height: 220,
                        width: double.infinity,

                        fit: BoxFit.cover,

                        errorBuilder:
                            (context, error, stackTrace) {

                          return Container(
                            height: 220,
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Padding(

                      padding:
                      const EdgeInsets.all(12),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(

                            film.judul,

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(

                            film.kategori,

                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(

                            children: [

                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),

                              const SizedBox(width: 5),

                              Text(

                                film.skorRating
                                    .toString(),

                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(

                            mainAxisAlignment:
                            MainAxisAlignment.end,

                            children: [

                              // EDIT
                              IconButton(

                                onPressed: () {

                                  Get.to(
                                          () =>
                                          EditFilmPage(
                                            film: film,
                                          ));
                                },

                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),

                              // DELETE
                              IconButton(

                                onPressed: () {

                                  Get.defaultDialog(

                                    title:
                                    "Hapus Film",

                                    middleText:
                                    "Yakin ingin menghapus film ini?",

                                    textConfirm:
                                    "Ya",

                                    textCancel:
                                    "Batal",

                                    confirmTextColor:
                                    Colors.white,

                                    onConfirm: () {

                                      controller
                                          .deleteFilm(
                                          film.id);

                                      Get.back();
                                    },
                                  );
                                },

                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
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
    );
  }
}