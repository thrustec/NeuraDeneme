import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_video_model.dart';

// ─────────────────────────────────────────────────────────────
// Supabase PostgREST — doğrudan bağlantı
// ─────────────────────────────────────────────────────────────
const String SUPABASE_URL =
    'https://griteunvazwekosffmjo.supabase.co/rest/v1';
const String SUPABASE_ANON_KEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
    'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdyaXRldW52YXp3ZWtvc2ZmbWpvIiwi'
    'cm9sZSI6ImFub24iLCJpYXQiOjE3NzU1OTA3OTksImV4cCI6MjA5MTE2Njc5OX0.'
    'q67C45Tve77Sj9hP0NRpXXIaSS1esajX3IE-TBZ-wIU';

Map<String, String> _headers() {
  return {
    'apikey': SUPABASE_ANON_KEY,
    'Authorization': 'Bearer $SUPABASE_ANON_KEY',
    'Accept-Profile': 'neura',
    'Content-Type': 'application/json',
  };
}
// ──────────────────────────────────────────────────────────

class ExerciseVideoService {
  /// Supabase'den egzersiz videolarını çeker.
  /// Tablo henüz oluşturulmadıysa mock verilere döner.
  static Future<List<EgzersizVideo>> getVideolar({
    String? kategori,
    String? hedefHastalik,
    String? zorlukSeviyesi,
    String? aramaMetni,
  }) async {
    try {
      // PostgREST sorgusu oluştur
      String url = '$SUPABASE_URL/egzersizVideolari?select=*'
          '&order=videoId.asc';

      if (kategori != null && kategori.isNotEmpty) {
        url += '&kategori=eq.$kategori';
      }
      if (hedefHastalik != null && hedefHastalik.isNotEmpty) {
        url += '&hedefHastalik=eq.$hedefHastalik';
      }
      if (zorlukSeviyesi != null && zorlukSeviyesi.isNotEmpty) {
        url += '&zorlukSeviyesi=eq.$zorlukSeviyesi';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> liste = json.decode(response.body);
        List<EgzersizVideo> videolar = liste
            .map((j) =>
                EgzersizVideo.fromJson(j as Map<String, dynamic>))
            .toList();

        // İstemci tarafı metin araması
        if (aramaMetni != null && aramaMetni.isNotEmpty) {
          final q = aramaMetni.toLowerCase();
          videolar = videolar
              .where((v) =>
                  v.baslik.toLowerCase().contains(q) ||
                  (v.aciklama?.toLowerCase().contains(q) ?? false) ||
                  v.kategori.toLowerCase().contains(q) ||
                  (v.hedefHastalik?.toLowerCase().contains(q) ?? false))
              .toList();
        }

        return videolar;
      }

      // Tablo yoksa veya hata varsa mock verilere dön
      return _mockVeriler(
        kategori: kategori,
        hedefHastalik: hedefHastalik,
        zorlukSeviyesi: zorlukSeviyesi,
        aramaMetni: aramaMetni,
      );
    } catch (e) {
      // Bağlantı hatası → mock veri
      return _mockVeriler(
        kategori: kategori,
        hedefHastalik: hedefHastalik,
        zorlukSeviyesi: zorlukSeviyesi,
        aramaMetni: aramaMetni,
      );
    }
  }

  /// Kategorileri getirir
  static List<String> getKategoriler() {
    return [
      'Tümü',
      'Denge',
      'Kuvvet',
      'Esneklik',
      'Kardiyovaskuler',
      'Solunum',
      'Kognitif',
    ];
  }

  /// Hastalık filtrelerini getirir
  static List<String> getHastaliklar() {
    return [
      'Tümü',
      'Parkinson',
      'MS',
      'ALS',
      'Alzheimer',
      'Ataksi',
      'Genel',
    ];
  }

  /// Zorluk seviyelerini getirir
  static List<String> getZorlukSeviyeleri() {
    return ['Tümü', 'Kolay', 'Orta', 'Zor'];
  }

  // ─── Mock Veriler ──────────────────────────────────────────
  // Supabase'de tablo oluşturulana kadar kullanılacak
  static List<EgzersizVideo> _mockVeriler({
    String? kategori,
    String? hedefHastalik,
    String? zorlukSeviyesi,
    String? aramaMetni,
  }) {
    List<EgzersizVideo> videolar = [
      EgzersizVideo(
        videoId: 1,
        baslik: 'Parkinson Denge Egzersizleri',
        aciklama:
            'Parkinson hastalarına yönelik temel denge eğitimi. '
            'Postüral stabiliteyi artırmaya odaklanır.',
        videoUrl: 'https://www.youtube.com/watch?v=example1',
        thumbnailUrl: null,
        kategori: 'Denge',
        hedefHastalik: 'Parkinson',
        zorlukSeviyesi: 'Kolay',
        sureDakika: 15,
        hedefBolge: 'Alt Ekstremite',
        ekipman: 'Yok',
      ),
      EgzersizVideo(
        videoId: 2,
        baslik: 'MS Hastalarında Üst Ekstremite Güçlendirme',
        aciklama:
            'Multipl Skleroz hastalarında kol ve omuz bölgesi '
            'güçlendirme egzersizleri.',
        videoUrl: 'https://www.youtube.com/watch?v=example2',
        thumbnailUrl: null,
        kategori: 'Kuvvet',
        hedefHastalik: 'MS',
        zorlukSeviyesi: 'Orta',
        sureDakika: 20,
        hedefBolge: 'Üst Ekstremite',
        ekipman: 'Theraband',
      ),
      EgzersizVideo(
        videoId: 3,
        baslik: 'ALS İçin Solunum Egzersizleri',
        aciklama:
            'ALS hastalarında solunum kas gücünü korumaya '
            'yönelik egzersizler.',
        videoUrl: 'https://www.youtube.com/watch?v=example3',
        thumbnailUrl: null,
        kategori: 'Solunum',
        hedefHastalik: 'ALS',
        zorlukSeviyesi: 'Kolay',
        sureDakika: 10,
        hedefBolge: 'Gövde',
        ekipman: 'Yok',
      ),
      EgzersizVideo(
        videoId: 4,
        baslik: 'Alzheimer Kognitif Motor Egzersizleri',
        aciklama:
            'Hafif-orta düzey Alzheimer hastalarında bilişsel '
            've motor becerileri birleştiren dual-task egzersizleri.',
        videoUrl: 'https://www.youtube.com/watch?v=example4',
        thumbnailUrl: null,
        kategori: 'Kognitif',
        hedefHastalik: 'Alzheimer',
        zorlukSeviyesi: 'Kolay',
        sureDakika: 12,
        hedefBolge: 'Tüm Vücut',
        ekipman: 'Yok',
      ),
      EgzersizVideo(
        videoId: 5,
        baslik: 'Genel Esneklik ve Germe Programı',
        aciklama:
            'Tüm nörolojik hasta grupları için uygun temel '
            'esneklik egzersizleri.',
        videoUrl: 'https://www.youtube.com/watch?v=example5',
        thumbnailUrl: null,
        kategori: 'Esneklik',
        hedefHastalik: 'Genel',
        zorlukSeviyesi: 'Kolay',
        sureDakika: 18,
        hedefBolge: 'Tüm Vücut',
        ekipman: 'Yok',
      ),
      EgzersizVideo(
        videoId: 6,
        baslik: 'Parkinson Yürüme Eğitimi',
        aciklama:
            'Donma fenomeni ve bradikinezi için ritimli yürüme '
            'egzersizleri ve ipuçları.',
        videoUrl: 'https://www.youtube.com/watch?v=example6',
        thumbnailUrl: null,
        kategori: 'Kardiyovaskuler',
        hedefHastalik: 'Parkinson',
        zorlukSeviyesi: 'Orta',
        sureDakika: 25,
        hedefBolge: 'Alt Ekstremite',
        ekipman: 'Yok',
      ),
      EgzersizVideo(
        videoId: 7,
        baslik: 'Ataksi İçin Koordinasyon Egzersizleri',
        aciklama:
            'Serebellar ataksi hastalarında ince motor ve '
            'koordinasyon becerilerini geliştiren egzersizler.',
        videoUrl: 'https://www.youtube.com/watch?v=example7',
        thumbnailUrl: null,
        kategori: 'Denge',
        hedefHastalik: 'Ataksi',
        zorlukSeviyesi: 'Orta',
        sureDakika: 22,
        hedefBolge: 'Tüm Vücut',
        ekipman: 'Denge Tahtası',
      ),
      EgzersizVideo(
        videoId: 8,
        baslik: 'MS Hastalarında Yorgunluk Yönetimi',
        aciklama:
            'Enerji tasarrufu teknikleri ve hafif aerobik '
            'egzersizlerle yorgunluk yönetimi.',
        videoUrl: 'https://www.youtube.com/watch?v=example8',
        thumbnailUrl: null,
        kategori: 'Kardiyovaskuler',
        hedefHastalik: 'MS',
        zorlukSeviyesi: 'Kolay',
        sureDakika: 15,
        hedefBolge: 'Tüm Vücut',
        ekipman: 'Yok',
      ),
      EgzersizVideo(
        videoId: 9,
        baslik: 'İleri Seviye Güçlendirme Programı',
        aciklama:
            'Hafif nörolojik semptomları olan hastalar için '
            'ileri düzey kuvvet antrenmanı.',
        videoUrl: 'https://www.youtube.com/watch?v=example9',
        thumbnailUrl: null,
        kategori: 'Kuvvet',
        hedefHastalik: 'Genel',
        zorlukSeviyesi: 'Zor',
        sureDakika: 30,
        hedefBolge: 'Tüm Vücut',
        ekipman: 'Dambıl',
      ),
      EgzersizVideo(
        videoId: 10,
        baslik: 'Otur-Kalk Fonksiyonel Egzersizler',
        aciklama:
            'Sandalyede oturarak yapılabilen güçlendirme ve '
            'denge egzersizleri. Tekerlekli sandalye '
            'kullanıcıları için de uygundur.',
        videoUrl: 'https://www.youtube.com/watch?v=example10',
        thumbnailUrl: null,
        kategori: 'Kuvvet',
        hedefHastalik: 'Genel',
        zorlukSeviyesi: 'Kolay',
        sureDakika: 20,
        hedefBolge: 'Üst Ekstremite',
        ekipman: 'Sandalye',
      ),
      EgzersizVideo(
        videoId: 11,
        baslik: 'Parkinson Tremor Kontrolü İçin Egzersizler',
        aciklama:
            'Tremor ve rijiditeyi azaltmaya yönelik hedefli '
            'el ve bilek egzersizleri.',
        videoUrl: 'https://www.youtube.com/watch?v=example11',
        thumbnailUrl: null,
        kategori: 'Esneklik',
        hedefHastalik: 'Parkinson',
        zorlukSeviyesi: 'Kolay',
        sureDakika: 12,
        hedefBolge: 'Üst Ekstremite',
        ekipman: 'Stres Topu',
      ),
      EgzersizVideo(
        videoId: 12,
        baslik: 'Nörolojik Rehabilitasyon Pilates',
        aciklama:
            'Nörolojik hasta gruplarına uyarlanmış modifiye '
            'Pilates egzersizleri.',
        videoUrl: 'https://www.youtube.com/watch?v=example12',
        thumbnailUrl: null,
        kategori: 'Esneklik',
        hedefHastalik: 'Genel',
        zorlukSeviyesi: 'Orta',
        sureDakika: 35,
        hedefBolge: 'Gövde',
        ekipman: 'Mat',
      ),
    ];

    // Filtreleme
    if (kategori != null && kategori != 'Tümü' && kategori.isNotEmpty) {
      videolar =
          videolar.where((v) => v.kategori == kategori).toList();
    }
    if (hedefHastalik != null &&
        hedefHastalik != 'Tümü' &&
        hedefHastalik.isNotEmpty) {
      videolar = videolar
          .where((v) => v.hedefHastalik == hedefHastalik)
          .toList();
    }
    if (zorlukSeviyesi != null &&
        zorlukSeviyesi != 'Tümü' &&
        zorlukSeviyesi.isNotEmpty) {
      videolar = videolar
          .where((v) => v.zorlukSeviyesi == zorlukSeviyesi)
          .toList();
    }
    if (aramaMetni != null && aramaMetni.isNotEmpty) {
      final q = aramaMetni.toLowerCase();
      videolar = videolar
          .where((v) =>
              v.baslik.toLowerCase().contains(q) ||
              (v.aciklama?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return videolar;
  }
}
