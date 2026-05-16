import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/komentar_model.dart';

class KomentarProvider {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<KomentarModel>> getKomentarByFilm(String filmId) async {
    final data = await _supabase
        .from('komentar')
        .select()
        .eq('film_id', filmId)
        .order('created_at', ascending: false);
    return (data as List).map((e) => KomentarModel.fromJson(e)).toList();
  }

  Future<void> tambahKomentar(KomentarModel komentar) async {
    await _supabase.from('komentar').insert(komentar.toJson());
  }
}
