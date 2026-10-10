import 'package:flutter/foundation.dart';
import '../models/report_model.dart';

/// Service/Store Sederhana untuk Manajemen State Laporan sebelum SQLite Tahap 5
class ReportStore {
  static final ReportStore _instance = ReportStore._internal();
  factory ReportStore() => _instance;
  ReportStore._internal();

  final ValueNotifier<List<ReportModel>> reportsNotifier =
      ValueNotifier<List<ReportModel>>(List.from(ReportModel.sampleReports));

  List<ReportModel> get reports => reportsNotifier.value;

  void addReport(ReportModel report) {
    final newReport = report.copyWith(
      id: (reportsNotifier.value.length + 1).toString(),
    );
    reportsNotifier.value = [newReport, ...reportsNotifier.value];
  }

  void updateReportStatus(String id, String newStatus) {
    reportsNotifier.value = reportsNotifier.value.map((report) {
      if (report.id == id) {
        return report.copyWith(status: newStatus);
      }
      return report;
    }).toList();
  }
}
