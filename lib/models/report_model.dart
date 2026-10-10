/// Model Data Laporan Pencemaran Sungai oleh Masyarakat
class ReportModel {
  final String? id;
  final String reporterName;
  final String riverName;
  final String location;
  final String severity; // 'Ringan', 'Sedang', 'Berat'
  final String description;
  final String date;
  final String status; // 'Pending', 'Diproses', 'Selesai'

  const ReportModel({
    this.id,
    required this.reporterName,
    required this.riverName,
    required this.location,
    required this.severity,
    required this.description,
    required this.date,
    this.status = 'Pending',
  });

  /// Konversi dari Map (Untuk Database SQLite lokal)
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id']?.toString(),
      reporterName: map['reporterName'] ?? 'Anonim',
      riverName: map['riverName'] ?? '',
      location: map['location'] ?? '',
      severity: map['severity'] ?? 'Sedang',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      status: map['status'] ?? 'Pending',
    );
  }

  /// Konversi ke Map (Untuk Database SQLite lokal)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'reporterName': reporterName,
      'riverName': riverName,
      'location': location,
      'severity': severity,
      'description': description,
      'date': date,
      'status': status,
    };
  }

  ReportModel copyWith({
    String? id,
    String? reporterName,
    String? riverName,
    String? location,
    String? severity,
    String? description,
    String? date,
    String? status,
  }) {
    return ReportModel(
      id: id ?? this.id,
      reporterName: reporterName ?? this.reporterName,
      riverName: riverName ?? this.riverName,
      location: location ?? this.location,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  /// Sample Dummy Data Laporan Awal
  static List<ReportModel> get sampleReports => [
        const ReportModel(
          id: '1',
          reporterName: 'Budi Santoso',
          riverName: 'Sungai Siak',
          location: 'Dermaga Boom Baru, Pekanbaru',
          severity: 'Sedang',
          description:
              'Ditemukan tumpukan plastik kardus dan botol mengapung di dekat tiang dermaga.',
          date: '2025-05-10 14:30',
          status: 'Diproses',
        ),
        const ReportModel(
          id: '2',
          reporterName: 'Rina Amelia',
          riverName: 'Sungai Air Hitam',
          location: 'Jembatan Payung Sekaki',
          severity: 'Berat',
          description:
              'Penumpukan batang kayu dan limbah sampah padat menutup sebagian besar badan air.',
          date: '2025-05-11 09:15',
          status: 'Pending',
        ),
        const ReportModel(
          id: '3',
          reporterName: 'Ahmad Fauzi',
          riverName: 'Sungai Sail',
          location: 'Samping Pasar Sail',
          severity: 'Ringan',
          description:
              'Sampah plastik sisa bungkus makanan rumah tangga di pinggir tanggul.',
          date: '2025-05-08 16:45',
          status: 'Selesai',
        ),
      ];
}
