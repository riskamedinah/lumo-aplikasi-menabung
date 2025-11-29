import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tabungan_model.dart';

class TabunganService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get semua tabungan user
  Future<List<Tabungan>> getTabungan() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final response = await _supabase
        .from('tabungan')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).map((item) => Tabungan.fromMap(item)).toList();
  }

  // Add tabungan baru
  Future<void> addTabungan(Tabungan tabungan) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _supabase.from('tabungan').insert({
      'user_id': user.id,
      'nama_tabungan': tabungan.namaTabungan,
      'target_tabungan': tabungan.targetTabungan,
      'total_terkumpul': tabungan.totalTerkumpul,
      'mata_uang': tabungan.mataUang,
      'rencana_pengisian': tabungan.rencanaPengisian,
      'nominal_pengisian': tabungan.nominalPengisian,
      'gambar_url': tabungan.gambarUrl,
    });
  }

  // TAMBAHKAN METHOD INI: Update tabungan
  Future<void> updateTabungan(Tabungan tabungan) async {
    await _supabase
        .from('tabungan')
        .update({
          'nama_tabungan': tabungan.namaTabungan,
          'target_tabungan': tabungan.targetTabungan,
          'mata_uang': tabungan.mataUang,
          'rencana_pengisian': tabungan.rencanaPengisian,
          'nominal_pengisian': tabungan.nominalPengisian,
          'gambar_url': tabungan.gambarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', tabungan.id);
  }

  // TAMBAHKAN METHOD INI: Tambah setoran (update total terkumpul)
  Future<void> tambahSetoran(
    String tabunganId,
    double jumlah,
    double totalBaru,
    String deskripsi,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    // Update total terkumpul di tabungan
    await _supabase
        .from('tabungan')
        .update({
          'total_terkumpul': totalBaru,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', tabunganId);
  }

  // Delete tabungan
  Future<void> deleteTabungan(String id) async {
    await _supabase.from('tabungan').delete().eq('id', id);
  }

  // Upload gambar tabungan
  Future<String> uploadTabunganImage(File imageFile, String tabunganId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final fileName =
        '${user.id}/$tabunganId/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _supabase.storage
        .from('tabungan_images')
        .upload(fileName, imageFile, fileOptions: FileOptions(upsert: true));

    return _supabase.storage.from('tabungan_images').getPublicUrl(fileName);
  }

  // Delete gambar tabungan
  Future<void> deleteTabunganImage(String imageUrl) async {
    // Extract file path dari URL
    final fileName = imageUrl.split('/').last;
    await _supabase.storage.from('tabungan_images').remove([fileName]);
  }

  // TAMBAHKAN METHOD INI: Get tabungan by ID
  Future<Tabungan?> getTabunganById(String id) async {
    try {
      final response =
          await _supabase.from('tabungan').select().eq('id', id).single();

      return Tabungan.fromMap(response);
    } catch (e) {
      print('Error getting tabungan by ID: $e');
      return null;
    }
  }
}
