import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/database_helper.dart';

/// State Management Provider untuk Laporan Pencemaran Sungai (SQLite Integrasi)
class ReportProvider extends ChangeNotifier {
  List<ReportModel> _reports = [];
  bool _isLoading = false;

  List<ReportModel> get reports => _reports;
  bool get isLoading => _isLoading;

  /// Inisialisasi Data dari Database SQLite
  Future<void> fetchReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reports = await DatabaseHelper.instance.getAllReports();
    } catch (e) {
      debugPrint('Error fetching reports: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tambah Laporan Baru ke Database
  Future<bool> addReport(ReportModel report) async {
    try {
      await DatabaseHelper.instance.insertReport(report);
      await fetchReports(); // Refresh data dari DB
      return true;
    } catch (e) {
      debugPrint('Error adding report: $e');
      return false;
    }
  }

  /// Perbarui Status Laporan
  Future<bool> updateStatus(String id, String newStatus) async {
    try {
      final intId = int.tryParse(id);
      if (intId != null) {
        await DatabaseHelper.instance.updateReportStatus(intId, newStatus);
        await fetchReports(); // Refresh data dari DB
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating report status: $e');
      return false;
    }
  }

  /// Hapus Laporan
  Future<bool> deleteReport(String id) async {
    try {
      final intId = int.tryParse(id);
      if (intId != null) {
        await DatabaseHelper.instance.deleteReport(intId);
        await fetchReports(); // Refresh data dari DB
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting report: $e');
      return false;
    }
  }
}
