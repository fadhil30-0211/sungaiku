import 'package:flutter_test/flutter_test.dart';
import 'package:sungaiku/main.dart';
import 'package:sungaiku/models/report_model.dart';
import 'package:sungaiku/models/river_model.dart';

void main() {
  testWidgets('Aplikasi SungaiKu dapat dirender dengan baik', (WidgetTester tester) async {
    await tester.pumpWidget(const SungaiKuApp());
    expect(find.text('SungaiKu - Beranda'), findsOneWidget);
  });

  group('Pengujian Unit Model Data SungaiKu', () {
    test('Model RiverModel harus mengembalikan sample data dengan benar', () {
      final sampleRivers = RiverModel.sampleRivers;
      expect(sampleRivers.isNotEmpty, true);
      expect(sampleRivers.first.name, 'Sungai Siak');
      expect(sampleRivers.first.cleanlinessIndex, 58);
    });

    test('Model ReportModel toMap dan fromMap harus konsisten', () {
      const report = ReportModel(
        id: '10',
        reporterName: 'Budi Test',
        riverName: 'Sungai Siak',
        location: 'Kec. Senapelan',
        severity: 'Berat',
        description: 'Tumpukan sampah plastik.',
        date: '2025-05-12 10:00',
        status: 'Pending',
      );

      final map = report.toMap();
      expect(map['reporterName'], 'Budi Test');
      expect(map['status'], 'Pending');

      final reconstructed = ReportModel.fromMap(map);
      expect(reconstructed.reporterName, report.reporterName);
      expect(reconstructed.riverName, report.riverName);
      expect(reconstructed.severity, report.severity);
    });
  });
}
