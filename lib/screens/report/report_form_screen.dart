import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/report_model.dart';
import '../../models/river_model.dart';
import '../../providers/report_provider.dart';

/// Layar Form Pelaporan Kebersihan Sungai (Tersimpan ke SQLite Database)
class ReportFormScreen extends StatefulWidget {
  final String? initialRiverName;

  const ReportFormScreen({super.key, this.initialRiverName});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _reporterNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedRiver;
  String _selectedSeverity = 'Sedang';
  bool _hasPhotoAttached = false;
  bool _isSubmitting = false;

  final List<String> _riversList =
      RiverModel.sampleRivers.map((r) => r.name).toList();

  @override
  void initState() {
    super.initState();
    if (widget.initialRiverName != null &&
        _riversList.contains(widget.initialRiverName)) {
      _selectedRiver = widget.initialRiverName;
    } else {
      _selectedRiver = _riversList.first;
    }
  }

  @override
  void dispose() {
    _reporterNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

      final newReport = ReportModel(
        reporterName: _reporterNameController.text.trim(),
        riverName: _selectedRiver ?? 'Sungai Siak',
        location: _locationController.text.trim(),
        severity: _selectedSeverity,
        description: _descriptionController.text.trim(),
        date: formattedDate,
        status: 'Pending',
      );

      // Simpan ke SQLite lewat Provider
      final success =
          await Provider.of<ReportProvider>(context, listen: false).addReport(newReport);

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        // Tampilkan Notifikasi Sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laporan Anda berhasil disimpan ke database lokal!'),
            backgroundColor: AppTheme.statusBaik,
            duration: Duration(seconds: 2),
          ),
        );

        // Reset Form
        _formKey.currentState!.reset();
        _reporterNameController.clear();
        _locationController.clear();
        _descriptionController.clear();
        setState(() {
          _hasPhotoAttached = false;
          _selectedSeverity = 'Sedang';
        });

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan laporan. Coba lagi.'),
            backgroundColor: AppTheme.statusBahaya,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapor Kebersihan Sungai'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card Informatif
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primaryColor),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Isi data laporan dengan benar. Data tersimpan permanen di database lokal SQLite.',
                        style: TextStyle(fontSize: 12, color: AppTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input Nama Pelapor
              const Text(
                'Nama Pelapor',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _reporterNameController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Ahmad Hidayat',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama pelapor tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Input Pilih Sungai
              const Text(
                'Pilih Lokasi Sungai',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedRiver,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.water_outlined),
                ),
                items: _riversList.map((river) {
                  return DropdownMenuItem(
                    value: river,
                    child: Text(river),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRiver = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Input Detail Patokan Lokasi
              const Text(
                'Detail / Patokan Lokasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Samping Jembatan II, Kec. Sail',
                  prefixIcon: Icon(Icons.pin_drop_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Detail lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Choice Tingkat Keparahan
              const Text(
                'Tingkat Keparahan Pencemaran',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Ringan', 'Sedang', 'Berat'].map((severity) {
                  final isSelected = _selectedSeverity == severity;
                  Color activeColor;
                  if (severity == 'Ringan') {
                    activeColor = AppTheme.statusBaik;
                  } else if (severity == 'Sedang') {
                    activeColor = AppTheme.statusWaspada;
                  } else {
                    activeColor = AppTheme.statusBahaya;
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            severity,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: activeColor,
                        backgroundColor: Colors.grey.shade200,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedSeverity = severity;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Deskripsi Masalah
              const Text(
                'Deskripsi Masalah / Catatan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Jelaskan kondisi tumpukan sampah atau pencemaran yang terjadi...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi laporan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Lampirkan Foto
              const Text(
                'Foto Bukti Lapangan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () {
                  setState(() {
                    _hasPhotoAttached = !_hasPhotoAttached;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _hasPhotoAttached
                        ? AppTheme.primaryColor.withOpacity(0.05)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _hasPhotoAttached
                          ? AppTheme.primaryColor
                          : Colors.grey.shade400,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _hasPhotoAttached
                            ? Icons.check_circle_outline
                            : Icons.add_a_photo_outlined,
                        size: 32,
                        color: _hasPhotoAttached
                            ? AppTheme.primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _hasPhotoAttached
                            ? '1 Foto Berhasil Dilampirkan (Klik untuk Ubah)'
                            : 'Klik untuk Mengunggah Foto Bukti Lapangan',
                        style: TextStyle(
                          fontSize: 12,
                          color: _hasPhotoAttached
                              ? AppTheme.primaryColor
                              : Colors.grey.shade700,
                          fontWeight: _hasPhotoAttached
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Kirim Laporan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitReport,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(_isSubmitting
                      ? 'Menyimpan ke SQLite...'
                      : 'Kirim Laporan Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
