import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/river_model.dart';
import '../widgets/status_badge.dart';
import '../report/report_form_screen.dart';

/// Layar Rincian/Detail Kondisi Kebersihan Sungai
class RiverDetailScreen extends StatelessWidget {
  final RiverModel river;

  const RiverDetailScreen({super.key, required this.river});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(river.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header Sungai
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            river.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        StatusBadge(status: river.status, fontSize: 13),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          river.location,
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DetailMetric(
                          icon: Icons.water_drop_outlined,
                          label: 'Debit Air',
                          value: river.waterLevel,
                        ),
                        _DetailMetric(
                          icon: Icons.access_time_outlined,
                          label: 'Update Terakhir',
                          value: river.lastUpdated,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card Indeks Kebersihan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Indeks Kebersihan Air',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: river.cleanlinessIndex / 100.0,
                              minHeight: 12,
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
                        const SizedBox(width: 12),
                        Text(
                          '${river.cleanlinessIndex}/100',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getRecommendation(river.cleanlinessIndex),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Deskripsi Kondisi Lapangan
            const Text(
              'Catatan Kondisi Lapangan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                river.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Tindakan Pelaporan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReportFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_alert),
                label: const Text('Buat Laporan untuk Sungai Ini'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRecommendation(int score) {
    if (score >= 75) {
      return 'Kondisi air sungai sangat baik dan aliran air aman dari pencemaran.';
    } else if (score >= 50) {
      return 'Kondisi air berisiko sedang. Diimbau tidak membuang sampah sembarangan.';
    } else {
      return 'Kondisi sungai tercemar! Diperlukan penanganan dan pembersihan segera.';
    }
  }
}

class _DetailMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
