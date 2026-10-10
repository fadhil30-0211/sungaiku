import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/report_model.dart';

/// Helper Service untuk Pengelolaan Database Lokal SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sungaiku.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE reports (
        id $idType,
        reporterName $textType,
        riverName $textType,
        location $textType,
        severity $textType,
        description $textType,
        date $textType,
        status $textType
      )
    ''');

    // Inisialisasi Data Awal (Seed Data)
    for (var report in ReportModel.sampleReports) {
      final map = report.toMap();
      map.remove('id'); // ID diset otomatis oleh autoincrement
      await db.insert('reports', map);
    }
  }

  /// Tambah Laporan Baru ke Database SQLite
  Future<int> insertReport(ReportModel report) async {
    final db = await instance.database;
    final map = report.toMap();
    map.remove('id');
    return await db.insert('reports', map);
  }

  /// Ambil Semua Laporan dari SQLite (Urutan Terbaru)
  Future<List<ReportModel>> getAllReports() async {
    final db = await instance.database;
    const orderBy = 'id DESC';
    final result = await db.query('reports', orderBy: orderBy);

    return result.map((json) => ReportModel.fromMap(json)).toList();
  }

  /// Update Status Laporan (Pending / Diproses / Selesai)
  Future<int> updateReportStatus(int id, String newStatus) async {
    final db = await instance.database;
    return db.update(
      'reports',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Hapus Laporan
  Future<int> deleteReport(int id) async {
    final db = await instance.database;
    return await db.delete(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Tutup Database Connection
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
