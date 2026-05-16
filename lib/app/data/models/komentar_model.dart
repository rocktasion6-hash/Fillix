class KomentarModel {
  String? id;
  String? userId;
  String? filmId;
  String? isi;
  String? namaUser;
  String? createdAt;

  KomentarModel({
    this.id,
    this.userId,
    this.filmId,
    this.isi,
    this.namaUser,
    this.createdAt,
  });

  factory KomentarModel.fromJson(Map<String, dynamic> json) {
    return KomentarModel(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      filmId: json['film_id']?.toString(),
      isi: json['isi'],
      namaUser: json['nama_user'],
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'film_id': filmId,
        'isi': isi,
        'nama_user': namaUser,
      };
}
