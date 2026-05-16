import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tiket_model.dart';

class TiketProvider {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<TiketModel>> getTiketByUser(String userId) async {
    final data = await _supabase
        .from('tiket')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (data as List).map((e) => TiketModel.fromJson(e)).toList();
  }

  Future<void> pesanTiket(TiketModel tiket) async {
    await _supabase.from('tiket').insert(tiket.toJson());
  }
}
