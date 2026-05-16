import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/film_model.dart';

class DetailFilmView extends StatelessWidget {
  const DetailFilmView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data film yang dikirim melalui arguments
    final FilmModel film = Get.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header dengan Gambar Sampul yang bisa menciut (SliverAppBar)
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(film.judul ?? "", style: TextStyle(shadows: [Shadow(blurRadius: 10, color: Colors.black)])),
              background: Image.network(
                film.gambarSampul ?? film.gambarPoster ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Poster Kecil
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(film.gambarPoster ?? "", width: 120),
                        ),
                        SizedBox(width: 16),
                        // Info Singkat
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(film.judul ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text("Kategori: ${film.kategori}"),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.orange, size: 20),
                                  SizedBox(width: 4),
                                  Text("${film.skorRating}/100", style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text("Rilis: ${film.tanggalRilis}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text("Ringkasan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      film.ringkasan ?? "Tidak ada ringkasan.",
                      style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey[800]),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 30),
                    // Tombol Tonton Trailer
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Logika buka URL trailer (bisa pakai url_launcher)
                        },
                        icon: Icon(Icons.play_arrow),
                        label: Text("Tonton Trailer"),
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}