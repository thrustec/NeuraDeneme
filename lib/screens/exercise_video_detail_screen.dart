import 'package:flutter/material.dart';
import '../models/exercise_video_model.dart';

class ExerciseVideoDetailScreen extends StatefulWidget {
  final EgzersizVideo video;
  const ExerciseVideoDetailScreen({super.key, required this.video});

  @override
  State<ExerciseVideoDetailScreen> createState() =>
      _ExerciseVideoDetailScreenState();
}

class _ExerciseVideoDetailScreenState
    extends State<ExerciseVideoDetailScreen> {
  bool _videoOynatiliyor = false;

  static const Color kPrimary = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final v = widget.video;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: _appBar(),
      bottomNavigationBar: _altAksiyon(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Video Oynatıcı Alanı ─────────────────────
            _videoOynatici(),
            const SizedBox(height: 16),

            // ── Video Başlığı ────────────────────────────
            Text(v.baslik,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B))),
            const SizedBox(height: 10),

            // ── Hızlı Bilgiler ──────────────────────────
            _hizliBilgiler(),
            const SizedBox(height: 16),

            // ── Açıklama ────────────────────────────────
            if (v.aciklama != null) ...[
              _bolumBaslik(Icons.description_outlined, 'Açıklama'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(v.aciklama!,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                        height: 1.6)),
              ),
              const SizedBox(height: 16),
            ],

            // ── Detay Bilgileri ──────────────────────────
            _bolumBaslik(Icons.info_outline, 'Detaylar'),
            const SizedBox(height: 8),
            _detayKart(),
            const SizedBox(height: 16),

            // ── Uyarılar ────────────────────────────────
            _uyariKutusu(),
          ],
        ),
      ),
    );
  }

  // ── Video Oynatıcı Alanı ──────────────────────────────────
  Widget _videoOynatici() {
    final v = widget.video;
    return GestureDetector(
      onTap: () {
        setState(() => _videoOynatiliyor = !_videoOynatiliyor);
        // Gerçek uygulamada burada url_launcher veya
        // video_player kullanılacak
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: _kategoriArkaplan(v.kategori),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _kategoriRenk(v.kategori).withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            // Arka plan ikonu
            Center(
              child: Icon(
                _kategoriIkon(v.kategori),
                size: 80,
                color:
                    _kategoriRenk(v.kategori).withOpacity(0.15),
              ),
            ),
            // Play / Pause butonu
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _videoOynatiliyor
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: _kategoriRenk(v.kategori),
                  size: 36,
                ),
              ),
            ),
            // Süre
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('${v.sureDakika} dakika',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            // Zorluk
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(v.zorlukRengi).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        Color(v.zorlukRengi).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.speed,
                        size: 14,
                        color: Color(v.zorlukRengi)),
                    const SizedBox(width: 4),
                    Text(v.zorlukSeviyesi,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(v.zorlukRengi))),
                  ],
                ),
              ),
            ),
            // Video bilgisi
            if (_videoOynatiliyor)
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline,
                          size: 13, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Video player entegrasyonu yapılacak',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Hızlı Bilgiler ───────────────────────────────────────
  Widget _hizliBilgiler() {
    final v = widget.video;
    return Row(
      children: [
        _hizliBilgiChip(
          ikon: _kategoriIkon(v.kategori),
          etiket: v.kategori,
          renk: _kategoriRenk(v.kategori),
          arkaplan: _kategoriArkaplan(v.kategori),
        ),
        const SizedBox(width: 8),
        if (v.hedefHastalik != null)
          _hizliBilgiChip(
            ikon: Icons.medical_services_outlined,
            etiket: v.hedefHastalik!,
            renk: kPrimary,
            arkaplan: const Color(0xFFEFF6FF),
          ),
        const SizedBox(width: 8),
        _hizliBilgiChip(
          ikon: Icons.timer_outlined,
          etiket: '${v.sureDakika} dk',
          renk: const Color(0xFF475569),
          arkaplan: const Color(0xFFF1F5F9),
        ),
      ],
    );
  }

  Widget _hizliBilgiChip({
    required IconData ikon,
    required String etiket,
    required Color renk,
    required Color arkaplan,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: arkaplan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 14, color: renk),
          const SizedBox(width: 4),
          Text(etiket,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: renk)),
        ],
      ),
    );
  }

  // ── Detay Kartı ───────────────────────────────────────────
  Widget _detayKart() {
    final v = widget.video;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _detaySatir('Kategori', v.kategori,
              Icons.category_outlined),
          _ayirici(),
          _detaySatir('Hedef Hastalık',
              v.hedefHastalik ?? 'Genel',
              Icons.medical_services_outlined),
          _ayirici(),
          _detaySatir('Hedef Bölge', v.hedefBolge ?? 'Belirtilmemiş',
              Icons.accessibility_new),
          _ayirici(),
          _detaySatir('Ekipman', v.ekipman ?? 'Gerekli değil',
              Icons.sports_gymnastics),
          _ayirici(),
          _detaySatir('Süre', '${v.sureDakika} dakika',
              Icons.timer_outlined),
          _ayirici(),
          _detaySatir('Zorluk', v.zorlukSeviyesi,
              Icons.speed,
              degerRengi: Color(v.zorlukRengi)),
        ],
      ),
    );
  }

  Widget _detaySatir(String etiket, String deger, IconData ikon,
      {Color? degerRengi}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(ikon, size: 18, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 10),
          Text(etiket,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF64748B))),
          const Spacer(),
          Text(deger,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      degerRengi ?? const Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _ayirici() {
    return const Divider(
        height: 1, color: Color(0xFFE2E8F0));
  }

  // ── Uyarı Kutusu ──────────────────────────────────────────
  Widget _uyariKutusu() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFFDE68A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_outlined,
              size: 20, color: Color(0xFFD97706)),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Önemli Uyarı',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E))),
                SizedBox(height: 4),
                Text(
                  'Egzersizlere başlamadan önce klinisyeninize '
                  'danışın. Ağrı veya rahatsızlık hissederseniz '
                  'egzersizi durdurun.',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF92400E),
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bölüm Başlığı ────────────────────────────────────────
  Widget _bolumBaslik(IconData ikon, String baslik) {
    return Row(
      children: [
        Icon(ikon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text(baslik,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.8)),
      ],
    );
  }

  // ── Alt Aksiyon Butonları ─────────────────────────────────
  Widget _altAksiyon() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Favorilere Ekle
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Favorilere eklendi'),
                      backgroundColor:
                          const Color(0xFF16A34A),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark_border,
                    size: 18),
                label: const Text('Kaydet'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimary,
                  side: const BorderSide(color: kPrimary),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Hastaya Ata
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Hastaya atama ekranı
                  // Merge sonrası bağlanacak
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Hastaya atama özelliği yakında'),
                      backgroundColor: kPrimary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_outlined,
                    size: 18),
                label: const Text('Hastaya Ata',
                    style: TextStyle(
                        fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────
  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B), size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Egzersiz Detayı',
          style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
              fontSize: 18)),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined,
              color: Color(0xFF1E293B)),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
              radius: 17,
              backgroundColor: kPrimary,
              child: const Text('AK',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold))),
        ),
      ],
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
              color: const Color(0xFFE2E8F0), height: 1)),
    );
  }

  // ── Yardımcılar ───────────────────────────────────────────
  Color _kategoriRenk(String kategori) {
    switch (kategori) {
      case 'Denge':
        return const Color(0xFF0891B2);
      case 'Kuvvet':
        return const Color(0xFFDC2626);
      case 'Esneklik':
        return const Color(0xFF9333EA);
      case 'Kardiyovaskuler':
        return const Color(0xFFD97706);
      case 'Solunum':
        return const Color(0xFF0F766E);
      case 'Kognitif':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _kategoriArkaplan(String kategori) {
    switch (kategori) {
      case 'Denge':
        return const Color(0xFFECFEFF);
      case 'Kuvvet':
        return const Color(0xFFFFF1F2);
      case 'Esneklik':
        return const Color(0xFFFAF5FF);
      case 'Kardiyovaskuler':
        return const Color(0xFFFFFBEB);
      case 'Solunum':
        return const Color(0xFFF0FDFA);
      case 'Kognitif':
        return const Color(0xFFEFF6FF);
      default:
        return const Color(0xFFF8FAFC);
    }
  }

  IconData _kategoriIkon(String kategori) {
    switch (kategori) {
      case 'Denge':
        return Icons.accessibility_new;
      case 'Kuvvet':
        return Icons.fitness_center;
      case 'Esneklik':
        return Icons.self_improvement;
      case 'Kardiyovaskuler':
        return Icons.directions_run;
      case 'Solunum':
        return Icons.air;
      case 'Kognitif':
        return Icons.psychology;
      default:
        return Icons.sports_gymnastics;
    }
  }
}
