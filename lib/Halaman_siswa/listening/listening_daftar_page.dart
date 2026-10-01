import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/siswa_model.dart';
import '../../services/api_service.dart';
import '../../widgets/student_background.dart';
import 'listening_siswa_page.dart';

/// Halaman Daftar Paket Modul Listening Siswa (Dinamis dari Backend Laravel).
/// Siswa dapat memilih paket latihan audio listening (misal: "At the Airport", "Ordering Food"),
/// memfilter berdasarkan tingkat kesulitan (Beginner, Intermediate, Advanced),
/// serta melihat riwayat modul yang telah selesai dikerjakan (+XP didapat).
class ListeningDaftarPage extends StatefulWidget {
  final SiswaModel? siswa;

  const ListeningDaftarPage({super.key, this.siswa});

  @override
  State<ListeningDaftarPage> createState() => _ListeningDaftarPageState();
}

class _ListeningDaftarPageState extends State<ListeningDaftarPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _allPackages = [];
  String _selectedDifficulty = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _difficultyFilters = [
    'Semua',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _fetchListeningList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchListeningList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.getDaftarListening(
      tingkat: _selectedDifficulty == 'Semua' ? null : _selectedDifficulty,
      siswaId: widget.siswa?.id,
    );

    if (!mounted) return;

    if (res['success'] == true) {
      final List<dynamic> raw = res['data'] ?? [];
      final List<Map<String, dynamic>> parsed = raw
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      setState(() {
        _allPackages = parsed;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = res['message'] ?? 'Gagal memuat daftar modul listening.';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredPackages {
    return _allPackages.where((item) {
      // Filter Tingkat Kesulitan
      if (_selectedDifficulty != 'Semua') {
        final diff = item['tingkat_kesulitan']?.toString().toLowerCase() ?? '';
        if (diff != _selectedDifficulty.toLowerCase()) {
          return false;
        }
      }

      // Filter Pencarian
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final judul = item['judul']?.toString().toLowerCase() ?? '';
        final desk = item['deskripsi']?.toString().toLowerCase() ?? '';
        final audio = item['audio_title']?.toString().toLowerCase() ?? '';
        if (!judul.contains(q) && !desk.contains(q) && !audio.contains(q)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Color _getDifficultyColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF059669); // Emerald Green
      case 'intermediate':
        return const Color(0xFF0056D2); // Royal Blue
      case 'advanced':
        return const Color(0xFFD97706); // Amber Orange
      default:
        return const Color(0xFF475569);
    }
  }

  Color _getDifficultyBgColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'beginner':
        return const Color(0xFFECFDF5);
      case 'intermediate':
        return const Color(0xFFEFF6FF);
      case 'advanced':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  void _openListeningPackage(Map<String, dynamic> item) async {
    final int? id = int.tryParse(item['id']?.toString() ?? '');
    if (id == null) return;

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ListeningSiswaPage(
          listeningId: id,
          siswa: widget.siswa,
        ),
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (result == true || mounted) {
      _fetchListeningList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudentBackground(
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchListeningList,
          color: const Color(0xFF0056D2),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Tombol Kembali, Judul Halaman)
                _buildHeader(),

                const SizedBox(height: 16),

                // 2. Hero Banner Interaktif
                _buildHeroBanner(),

                const SizedBox(height: 20),

                // 3. Search Bar
                _buildSearchBar(),

                const SizedBox(height: 14),

                // 4. Filter Chips (Semua, Beginner, Intermediate, Advanced)
                _buildFilterChips(),

                const SizedBox(height: 18),

                // 5. Header Jumlah Paket
                _buildListCounterHeader(),

                const SizedBox(height: 12),

                // 6. Daftar Kartu Paket Listening
                _buildPackageList(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Tombol Kembali
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          elevation: 1,
          shadowColor: Colors.black12,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(14),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF0F172A),
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Latihan Listening',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                'Asah pemahaman mendengarmu lewat audio interaktif',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        // Tombol Refresh
        IconButton(
          onPressed: _fetchListeningList,
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0056D2)),
          tooltip: 'Segarkan data',
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    final int completedCount = _allPackages.where((p) {
      final id = int.tryParse(p['id']?.toString() ?? '');
      return p['is_completed'] == true || (id != null && ApiService.isListeningCompleted(id));
    }).length;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0056D2), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0056D2).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Lingkaran ornamen abstrak
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    flex: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.headphones_rounded, size: 13, color: Colors.white),
                              const SizedBox(width: 5),
                              Text(
                                'Audio Practice',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pilih Paket Listening',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completedCount dari ${_allPackages.length} paket telah diselesaikan.',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/images/rakun_listening.png',
                        height: 95,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, st) {
                          return const Icon(
                            Icons.headset_mic_rounded,
                            size: 64,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF0F172A)),
        decoration: InputDecoration(
          hintText: 'Cari topik atau judul listening...',
          hintStyle: GoogleFonts.poppins(fontSize: 12.5, color: const Color(0xFF94A3B8)),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0056D2), size: 22),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _difficultyFilters.map((diff) {
          final isSelected = _selectedDifficulty == diff;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(diff),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  _selectedDifficulty = diff;
                });
              },
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF0056D2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF0056D2) : const Color(0xFFE2E8F0),
                ),
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListCounterHeader() {
    final count = _filteredPackages.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Paket Soal Tersedia',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        Text(
          '$count Paket',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildPackageList() {
    if (_isLoading) {
      return Container(
        height: 260,
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF0056D2)),
            SizedBox(height: 14),
            Text('Memuat paket listening...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFEE2E2)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: Color(0xFFEF4444)),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12.5, color: const Color(0xFF334155)),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: _fetchListeningList,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056D2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final packages = _filteredPackages;

    if (packages.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 52, color: Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text(
              'Tidak ada paket listening ditemukan',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Coba sesuaikan kata kunci pencarian atau ubah filter tingkat kesulitan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = packages[index];
        final id = int.tryParse(item['id']?.toString() ?? '') ?? 0;
        final bool isCompleted = item['is_completed'] == true || ApiService.isListeningCompleted(id);
        final String diff = item['tingkat_kesulitan']?.toString() ?? 'Beginner';
        final String kelas = item['tingkat_kelas']?.toString() ?? 'Semua Kelas';
        final String judul = item['judul']?.toString() ?? 'Judul Paket';
        final String deskripsi = item['deskripsi']?.toString() ?? '';
        final String durasi = item['durasi']?.toString() ?? '02:00';
        final int jumlahSoal = item['jumlah_soal'] is int ? item['jumlah_soal'] : 4;
        final int xp = item['xp_reward'] is int ? item['xp_reward'] : 50;

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => _openListeningPackage(item),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCompleted ? const Color(0xFF10B981).withValues(alpha: 0.35) : const Color(0xFFE2E8F0),
                  width: isCompleted ? 1.5 : 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row Tag: Level & Kelas & Status Selesai
                  Row(
                    children: [
                      // Badge Level
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyBgColor(diff),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          diff,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _getDifficultyColor(diff),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Badge Kelas
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          kelas,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Selesai Badge
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(
                                'Selesai',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Judul Paket Listening
                  Text(
                    judul,
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      height: 1.25,
                    ),
                  ),

                  if (deskripsi.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      deskripsi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Metadata Info (Durasi, Soal, XP) + Tombol Action
                  Row(
                    children: [
                      // Durasi Audio
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 15, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            durasi,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      // Jumlah Soal
                      Row(
                        children: [
                          const Icon(Icons.quiz_outlined, size: 15, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            '$jumlahSoal Soal',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      // Reward XP
                      Row(
                        children: [
                          const Icon(Icons.stars_rounded, size: 16, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 4),
                          Text(
                            '+$xp XP',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFD97706),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Tombol Mulai / Ulangi
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.white : const Color(0xFF0056D2),
                          borderRadius: BorderRadius.circular(10),
                          border: isCompleted
                              ? Border.all(color: const Color(0xFF0056D2), width: 1.2)
                              : null,
                          boxShadow: isCompleted
                              ? null
                              : [
                                  BoxShadow(
                                    color: const Color(0xFF0056D2).withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isCompleted ? 'Ulangi' : 'Mulai',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isCompleted ? const Color(0xFF0056D2) : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isCompleted ? Icons.replay_rounded : Icons.arrow_forward_rounded,
                              size: 14,
                              color: isCompleted ? const Color(0xFF0056D2) : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
