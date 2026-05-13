class FilmModel {
  String? id;
  String? judul;
  String? ringkasan;
  String? gambarPoster;
  String? gambarSampul;
  int? tanggalRilis; // Menggunakan int karena di JSON berupa timestamp/angka
  int? skorRating;   // Menggunakan int sesuai data "44"
  String? kategori;
  String? urlTrailer;

  FilmModel({
    this.id,
    this.judul,
    this.ringkasan,
    this.gambarPoster,
    this.gambarSampul,
    this.tanggalRilis,
    this.skorRating,
    this.kategori,
    this.urlTrailer,
  });

  // Mapping dari JSON ke Object
  factory FilmModel.fromJson(Map<String, dynamic> json) {
  return FilmModel(
    id: json['id']?.toString(),
    judul: json['judul'],
    ringkasan: json['ringkasan'],
    gambarPoster: json['gambar_poster'],
    gambarSampul: json['gambar_sampul'],
    // Gunakan tryParse untuk mengantisipasi jika API mengirim String "1778302687"
    tanggalRilis: json['tanggal_rilis'] is int 
        ? json['tanggal_rilis'] 
        : int.tryParse(json['tanggal_rilis']?.toString() ?? ""),
    // Ini adalah penyebab error di gambar: API mengirim "3" (String), model minta int
    skorRating: json['skor_rating'] is int 
        ? json['skor_rating'] 
        : int.tryParse(json['skor_rating']?.toString() ?? ""),
    kategori: json['kategori'],
    urlTrailer: json['url_trailer'],
  );
}

  // Mapping dari Object ke JSON (untuk Create/Update)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['judul'] = judul;
    data['ringkasan'] = ringkasan;
    data['gambar_poster'] = gambarPoster;
    data['gambar_sampul'] = gambarSampul;
    data['tanggal_rilis'] = tanggalRilis;
    data['skor_rating'] = skorRating;
    data['kategori'] = kategori;
    data['url_trailer'] = urlTrailer;
    return data;
  }
}