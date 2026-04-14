/// Egzersiz videosu modeli
/// Tablo: neura.egzersizVideolari
class EgzersizVideo {
  final int videoId;
  final String baslik;
  final String? aciklama;
  final String videoUrl;          // YouTube veya doğrudan video linki
  final String? thumbnailUrl;     // Küçük resim
  final String kategori;          // "Denge", "Kuvvet", "Esneklik", "Kardiyovasküler", "Solunum", "Kognitif"
  final String? hedefHastalik;    // "Parkinson", "MS", "ALS", "Alzheimer", "Ataksi", "Genel"
  final String zorlukSeviyesi;    // "Kolay", "Orta", "Zor"
  final int sureDakika;           // Video süresi (dakika)
  final String? hedefBolge;       // "Üst Ekstremite", "Alt Ekstremite", "Gövde", "Tüm Vücut"
  final String? ekipman;          // "Yok", "Dambıl", "Theraband", "Denge Tahtası" vb.
  final bool pilatFormundaMi;     // Platformda mı (Supabase storage) yoksa harici link mi
  final String? olusturmaTarihi;

  EgzersizVideo({
    required this.videoId,
    required this.baslik,
    this.aciklama,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.kategori,
    this.hedefHastalik,
    required this.zorlukSeviyesi,
    required this.sureDakika,
    this.hedefBolge,
    this.ekipman,
    this.pilatFormundaMi = false,
    this.olusturmaTarihi,
  });

  factory EgzersizVideo.fromJson(Map<String, dynamic> json) {
    return EgzersizVideo(
      videoId:          json['videoId'] ?? 0,
      baslik:           json['baslik'] ?? '',
      aciklama:         json['aciklama'],
      videoUrl:         json['videoUrl'] ?? '',
      thumbnailUrl:     json['thumbnailUrl'],
      kategori:         json['kategori'] ?? 'Genel',
      hedefHastalik:    json['hedefHastalik'],
      zorlukSeviyesi:   json['zorlukSeviyesi'] ?? 'Orta',
      sureDakika:       json['sureDakika'] ?? 0,
      hedefBolge:       json['hedefBolge'],
      ekipman:          json['ekipman'],
      pilatFormundaMi:  json['pilatFormundaMi'] ?? false,
      olusturmaTarihi:  json['olusturmaTarihi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId':         videoId,
      'baslik':          baslik,
      'aciklama':        aciklama,
      'videoUrl':        videoUrl,
      'thumbnailUrl':    thumbnailUrl,
      'kategori':        kategori,
      'hedefHastalik':   hedefHastalik,
      'zorlukSeviyesi':  zorlukSeviyesi,
      'sureDakika':      sureDakika,
      'hedefBolge':      hedefBolge,
      'ekipman':         ekipman,
      'pilatFormundaMi': pilatFormundaMi,
      'olusturmaTarihi': olusturmaTarihi,
    };
  }

  /// Zorluk seviyesine göre renk
  int get zorlukRengi {
    switch (zorlukSeviyesi) {
      case 'Kolay':
        return 0xFF16A34A; // Yeşil
      case 'Orta':
        return 0xFFD97706; // Turuncu
      case 'Zor':
        return 0xFFDC2626; // Kırmızı
      default:
        return 0xFF64748B;
    }
  }

  /// Kategori ikonunu belirle (Flutter Icons adıyla)
  String get kategoriIkonAdi {
    switch (kategori) {
      case 'Denge':
        return 'balance';
      case 'Kuvvet':
        return 'fitness_center';
      case 'Esneklik':
        return 'self_improvement';
      case 'Kardiyovaskuler':
        return 'directions_run';
      case 'Solunum':
        return 'air';
      case 'Kognitif':
        return 'psychology';
      default:
        return 'sports_gymnastics';
    }
  }
}
