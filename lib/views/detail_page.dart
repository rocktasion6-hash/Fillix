import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/film_model.dart';

class DetailPage extends StatelessWidget {

  final Film film;

  const DetailPage({
    super.key,
    required this.film,
  });

  Future<void> openTrailer() async {

    final Uri url =
    Uri.parse(film.urlTrailer);

    if (await canLaunchUrl(url)) {

      await launchUrl(
        url,
        mode:
        LaunchMode.externalApplication,
      );

    } else {

      throw Exception(
          "Tidak bisa membuka trailer");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: CustomScrollView(

        slivers: [

          // APPBAR IMAGE
          SliverAppBar(

            expandedHeight: 280,

            pinned: true,

            backgroundColor: Colors.black,

            foregroundColor: Colors.white,

            flexibleSpace: FlexibleSpaceBar(

              background: Image.network(

                film.gambarSampul,

                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {

                  return Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // CONTENT
          SliverToBoxAdapter(

            child: Padding(

              padding:
              const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // POSTER + INFO
                  Row(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      ClipRRect(

                        borderRadius:
                        BorderRadius.circular(12),

                        child: Image.network(

                          film.gambarPoster,

                          width: 120,
                          height: 170,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (context, error, stackTrace) {

                            return Container(
                              width: 120,
                              height: 170,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(

                              film.judul,

                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontSize: 26,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(

                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration:
                              BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                BorderRadius.circular(
                                    20),
                              ),

                              child: Text(

                                film.kategori,

                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Row(

                              children: [

                                const Icon(
                                  Icons.star,
                                  color:
                                  Colors.amber,
                                ),

                                const SizedBox(width: 5),

                                Text(

                                  film.skorRating
                                      .toString(),

                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            Text(

                              "Rilis: ${film.tanggalRilis}",

                              style:
                              const TextStyle(
                                color:
                                Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // RINGKASAN
                  const Text(

                    "Ringkasan",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    film.ringkasan,

                    style: TextStyle(
                      color:
                      Colors.grey.shade300,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BUTTON TRAILER
                  SizedBox(

                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.red,
                      ),

                      onPressed: openTrailer,

                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),

                      label: const Text(

                        "Tonton Trailer",

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
          ),
        ],
      ),
    );
  }
}