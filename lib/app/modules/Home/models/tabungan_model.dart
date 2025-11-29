class Tabungan {
  final String id;
  final String userId;
  final String namaTabungan;
  final double targetTabungan;
  final double totalTerkumpul;
  final String mataUang;
  final String rencanaPengisian;
  final double nominalPengisian;
  final String? gambarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tabungan({
    required this.id,
    required this.userId,
    required this.namaTabungan,
    required this.targetTabungan,
    required this.totalTerkumpul,
    required this.mataUang,
    required this.rencanaPengisian,
    required this.nominalPengisian,
    this.gambarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // Progress percentage - DINAMIS dari totalTerkumpul
  double get progress {
    if (targetTabungan == 0) return 0;
    return (totalTerkumpul / targetTabungan).clamp(0.0, 1.0);
  }

  // Factory method dari Map
  factory Tabungan.fromMap(Map<String, dynamic> map) {
    return Tabungan(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      namaTabungan: map['nama_tabungan'] ?? '',
      targetTabungan: (map['target_tabungan'] as num?)?.toDouble() ?? 0,
      totalTerkumpul: (map['total_terkumpul'] as num?)?.toDouble() ?? 0,
      mataUang: map['mata_uang'] ?? 'Indonesia Rupiah (Rp)',
      rencanaPengisian: map['rencana_pengisian'] ?? 'harian',
      nominalPengisian: (map['nominal_pengisian'] as num?)?.toDouble() ?? 0,
      gambarUrl: map['gambar_url'],
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'nama_tabungan': namaTabungan,
      'target_tabungan': targetTabungan,
      'total_terkumpul': totalTerkumpul,
      'mata_uang': mataUang,
      'rencana_pengisian': rencanaPengisian,
      'nominal_pengisian': nominalPengisian,
      'gambar_url': gambarUrl,
    };
  }

  // TAMBAHKAN METHOD INI: Copy with untuk update
  Tabungan copyWith({
    String? id,
    String? userId,
    String? namaTabungan,
    double? targetTabungan,
    double? totalTerkumpul,
    String? mataUang,
    String? rencanaPengisian,
    double? nominalPengisian,
    String? gambarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tabungan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      namaTabungan: namaTabungan ?? this.namaTabungan,
      targetTabungan: targetTabungan ?? this.targetTabungan,
      totalTerkumpul: totalTerkumpul ?? this.totalTerkumpul,
      mataUang: mataUang ?? this.mataUang,
      rencanaPengisian: rencanaPengisian ?? this.rencanaPengisian,
      nominalPengisian: nominalPengisian ?? this.nominalPengisian,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // TAMBAHKAN METHOD INI: Untuk update data tabungan
  Tabungan updateData({
    String? namaTabungan,
    double? targetTabungan,
    String? rencanaPengisian,
    double? nominalPengisian,
    String? gambarUrl,
  }) {
    return Tabungan(
      id: id,
      userId: userId,
      namaTabungan: namaTabungan ?? this.namaTabungan,
      targetTabungan: targetTabungan ?? this.targetTabungan,
      totalTerkumpul: totalTerkumpul, // Tetap sama
      mataUang: mataUang, // Tetap sama
      rencanaPengisian: rencanaPengisian ?? this.rencanaPengisian,
      nominalPengisian: nominalPengisian ?? this.nominalPengisian,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      createdAt: createdAt, // Tetap sama
      updatedAt: DateTime.now(), // Update timestamp
    );
  }

  // TAMBAHKAN METHOD INI: Untuk tambah setoran
  Tabungan tambahSetoran(double jumlah) {
    return Tabungan(
      id: id,
      userId: userId,
      namaTabungan: namaTabungan,
      targetTabungan: targetTabungan,
      totalTerkumpul: totalTerkumpul + jumlah,
      mataUang: mataUang,
      rencanaPengisian: rencanaPengisian,
      nominalPengisian: nominalPengisian,
      gambarUrl: gambarUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(), // Update timestamp
    );
  }

  // TAMBAHKAN METHOD INI: Cek apakah target sudah tercapai
  bool get isTargetTercapai {
    return totalTerkumpul >= targetTabungan;
  }

  // TAMBAHKAN METHOD INI: Sisa yang perlu dikumpulkan
  double get sisaKekurangan {
    return (targetTabungan - totalTerkumpul).clamp(0.0, double.infinity);
  }
}
