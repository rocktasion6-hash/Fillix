class TiketModel {
  String? id;
  String? userId;
  String? filmId;
  String? judulFilm;
  String? tanggalTayang;
  int? jumlahKursi;
  String? createdAt;

  TiketModel({
    this.id,
    this.userId,
    this.filmId,
    this.judulFilm,
    this.tanggalTayang,
    this.jumlahKursi,
    this.createdAt,
  });

  factory TiketModel.fromJson(Map<String, dynamic> json) {
    return TiketModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      filmId: json['film_id']?.toString(),
      judulFilm: json['judul_film'],
      tanggalTayang: json['tanggal_tayang'],
      jumlahKursi: json['jumlah_kursi'] is int
          ? json['jumlah_kursi']
          : int.tryParse(json['jumlah_kursi']?.toString() ?? ''),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'film_id': filmId,
        'judul_film': judulFilm,
        'tanggal_tayang': tanggalTayang,
        'jumlah_kursi': jumlahKursi,
      };
}
