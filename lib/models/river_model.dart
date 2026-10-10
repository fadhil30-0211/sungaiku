/// Model Data Sungai untuk Pemantauan Indeks Kebersihan
class RiverModel {
  final String id;
  final String name;
  final String location;
  final String status; // 'Baik', 'Waspada', 'Bahaya'
  final int cleanlinessIndex; // 0 - 100
  final String waterLevel; // 'Normal', 'Siaga', 'Waspada'
  final String description;
  final String lastUpdated;

  const RiverModel({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.cleanlinessIndex,
    required this.waterLevel,
    required this.description,
    required this.lastUpdated,
  });

  /// Dummy Data Sungai Wilayah Pekanbaru untuk Simulasi
  static List<RiverModel> get sampleRivers => [
        const RiverModel(
          id: 'R01',
          name: 'Sungai Siak',
          location: 'Kec. Senapelan, Pekanbaru',
          status: 'Waspada',
          cleanlinessIndex: 58,
          waterLevel: 'Siaga II',
          description:
              'Aliran utama sungai Pekanbaru. Terjadi penumpukan limbah domestik dan eceng gondok di beberapa titik dekat dermaga.',
          lastUpdated: '10 Mins Lalu',
        ),
        const RiverModel(
          id: 'R02',
          name: 'Sungai Sail',
          location: 'Kec. Sail, Pekanbaru',
          status: 'Waspada',
          cleanlinessIndex: 62,
          waterLevel: 'Normal',
          description:
              'Kondisi air agak keruh. Terdapat timbulan sampah plastik ringan di sekitar bantaran jembatan Sail.',
          lastUpdated: '1 Jam Lalu',
        ),
        const RiverModel(
          id: 'R03',
          name: 'Sungai Umban',
          location: 'Kec. Rumbai, Pekanbaru',
          status: 'Baik',
          cleanlinessIndex: 85,
          waterLevel: 'Normal',
          description:
              'Aliran lancar, vegetasi bantaran terjaga baik, dan tingkat pembuangan sampah relatif sangat rendah.',
          lastUpdated: '3 Jam Lalu',
        ),
        const RiverModel(
          id: 'R04',
          name: 'Sungai Air Hitam',
          location: 'Kec. Payung Sekaki, Pekanbaru',
          status: 'Bahaya',
          cleanlinessIndex: 35,
          waterLevel: 'Waspada',
          description:
              'Ditemukan pendangkalan dan penyumbatan sampah padat yang signifikan yang berpotensi memicu genangan air saat hujan deras.',
          lastUpdated: '30 Mins Lalu',
        ),
      ];
}
