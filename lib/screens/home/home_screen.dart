import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/river_model.dart';
import '../river/river_detail_screen.dart';
import '../widgets/status_badge.dart';

/// Layar Beranda / Dashboard Utama SungaiKu
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<RiverModel> _allRivers = RiverModel.sampleRivers;
  List<RiverModel> _filteredRivers = [];
  void _filterRivers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRivers = _allRivers;
      } else {
        _filteredRivers = _allRivers
            .where((river) =>
                river.name.toLowerCase().contains(query.toLowerCase()) ||
                river.location.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalBaik = _allRivers.where((r) => r.status == 'Baik').length;
    final int totalWaspada = _allRivers.where((r) => r.status == 'Waspada').length;
    final int totalBahaya = _allRivers.where((r) => r.status == 'Bahaya').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SungaiKu - Beranda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Header Welcoming
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang di SungaiKu 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Pantau kebersihan dan debit air sungai di wilayah Pekanbaru.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ringkasan Statistik Kebersihan
            const Text(
              'Ringkasan Status Sungai',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatCard(
                  title: 'Kondisi Baik',
                  count: '$totalBaik',
                  color: AppTheme.statusBaik,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  title: 'Waspada',
                  count: '$totalWaspada',
                  color: AppTheme.statusWaspada,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  title: 'Bahaya',
                  count: '$totalBahaya',
                  color: AppTheme.statusBahaya,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Bar & Judul Daftar
            TextField(
              onChanged: _filterRivers,
              decoration: const InputDecoration(
                hintText: 'Cari nama sungai atau kecamatan...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Daftar Sungai Dipantau',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Daftar River Card
            _filteredRivers.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text(
                        'Tidak ada sungai yang cocok dengan pencarian.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredRivers.length,
                    itemBuilder: (context, index) {
                      final river = _filteredRivers[index];
                      return _RiverCard(river: river);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiverCard extends StatelessWidget {
  final RiverModel river;

  const _RiverCard({required this.river});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RiverDetailScreen(river: river),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    river.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StatusBadge(status: river.status),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    river.location,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Indeks Kebersihan:',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: river.cleanlinessIndex / 100.0,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          river.cleanlinessIndex > 75
                              ? AppTheme.statusBaik
                              : (river.cleanlinessIndex > 50
                                  ? AppTheme.statusWaspada
                                  : AppTheme.statusBahaya),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${river.cleanlinessIndex}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
