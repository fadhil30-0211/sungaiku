import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/report_model.dart';
import '../../providers/report_provider.dart';
import '../widgets/status_badge.dart';

/// Layar Riwayat Laporan Masyarakat (Database SQLite Integrasi)
class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  String _selectedStatusFilter = 'Semua';

  void _showReportDetailDialog(BuildContext context, ReportModel report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Laporan #${report.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  StatusBadge(status: report.status, fontSize: 13),
                ],
              ),
              const Divider(height: 20),
              _InfoRow(label: 'Pelapor', value: report.reporterName),
              _InfoRow(label: 'Sungai', value: report.riverName),
              _InfoRow(label: 'Lokasi', value: report.location),
              _InfoRow(label: 'Keparahan', value: report.severity),
              _InfoRow(label: 'Waktu Lapor', value: report.date),
              const SizedBox(height: 10),
              const Text(
                'Deskripsi Masalah:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report.description,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),

              // Update Status Laporan di Database SQLite
              const Text(
                'Ubah Status Laporan (SQLite DB):',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Pending', 'Diproses', 'Selesai'].map((status) {
                  final isCurrent = report.status == status;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(
                            color: isCurrent
                                ? AppTheme.primaryColor
                                : Colors.grey.shade300,
                          ),
                          backgroundColor: isCurrent
                              ? AppTheme.primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        onPressed: () async {
                          if (report.id != null) {
                            final success = await Provider.of<ReportProvider>(
                                    context,
                                    listen: false)
                                .updateStatus(report.id!, status);

                            if (context.mounted) {
                              Navigator.pop(bottomSheetContext);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Status Laporan #${report.id} diperbarui ke $status di SQLite'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Tombol Hapus Laporan
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    if (report.id != null) {
                      final success = await Provider.of<ReportProvider>(
                              context,
                              listen: false)
                          .deleteReport(report.id!);

                      if (context.mounted) {
                        Navigator.pop(bottomSheetContext);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Laporan #${report.id} dihapus'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  icon: const Icon(Icons.delete_outline, color: AppTheme.statusBahaya),
                  label: const Text(
                    'Hapus Laporan Ini',
                    style: TextStyle(color: AppTheme.statusBahaya),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Laporan'),
      ),
      body: Column(
        children: [
          // Filter Chips Status
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Semua', 'Pending', 'Diproses', 'Selesai']
                    .map((status) {
                  final isSelected = _selectedStatusFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedStatusFilter = status;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Lista Laporan Consumer
          Expanded(
            child: Consumer<ReportProvider>(
              builder: (context, reportProvider, child) {
                if (reportProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = reportProvider.reports;
                final filteredList = reports.where((report) {
                  if (_selectedStatusFilter == 'Semua') return true;
                  return report.status.toLowerCase() ==
                      _selectedStatusFilter.toLowerCase();
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada laporan di database lokal.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => reportProvider.fetchReports(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final report = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          onTap: () => _showReportDetailDialog(context, report),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                report.riverName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              StatusBadge(status: report.status),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '📍 ${report.location}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pelapor: ${report.reporterName} • Waktu: ${report.date}',
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                report.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
