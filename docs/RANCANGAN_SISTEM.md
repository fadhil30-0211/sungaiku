# Rancangan Sistem - Aplikasi Mobile "SungaiKu"
**Mata Kuliah:** Rekayasa Perangkat Lunak (RPL) - Semester 4  
**Institusi:** USTI Pekanbaru  
**Teknologi:** Flutter (Android)  

---

## 1. Pendahuluan & Konsep Aplikasi
**SungaiKu** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pemantauan kebersihan dan pelaporan pencemaran/penumpukan sampah di aliran sungai (khususnya wilayah Pekanbaru dan sekitarnya). Aplikasi ini menghubungkan masyarakat umum dengan pihak pengelola/relawan sungai.

### Masalah yang Diselesaikan:
1. Kurangnya akses informasi real-time mengenai kondisi kebersihan dan tingkat keandalan sungai lokal.
2. Kesulitan masyarakat dalam menyampaikan laporan pencemaran/sampah sungai secara terstruktur beserta bukti foto dan lokasi.
3. Ketiadaan sistem pencatatan laporan yang dapat dipantau status penanganannya (Pending, Diproses, Selesai).

---

## 2. Pengguna dan Peran (Actor & Roles)
1. **Masyarakat / Pelapor (User):**
   - Melihat ringkasan kondisi dan indeks kebersihan sungai.
   - Membuat laporan baru pencemaran/sampah sungai (lokasi, deskripsi, foto).
   - Memantau status laporan yang pernah dikirimkan.
2. **Admin / Pengelola Sungai:**
   - Memverifikasi dan memperbarui status laporan masyarakat.
   - Mengelola data master sungai dan edukasi/tips kebersihan sungai.

---

## 3. Spesifikasi Use Case (RPL Standard)

### A. Daftar Use Case
| ID Use Case | Nama Use Case | Aktor | Deskripsi Singkat |
|-------------|---------------|-------|-------------------|
| UC-01 | Melihat Dashboard & Kondisi Sungai | User, Admin | Menampilkan daftar sungai, skor/kondisi kebersihan, dan berita/tips. |
| UC-02 | Membuat Laporan Pencemaran | User | Mengisi form laporan pencemaran sungai (lokasi, tingkat keparahan, deskripsi, foto). |
| UC-03 | Melihat Riwayat Laporan | User | Menampilkan daftar laporan pengguna beserta status tindak lanjut. |
| UC-04 | Mengelola Status Laporan | Admin | Mengubah status laporan dari *Pending* -> *Diproses* -> *Selesai*. |
| UC-05 | Mengelola Data Sungai (SQLite) | System | Menyimpan, membaca, dan memperbarui data laporan di penyimpanan lokal database. |

### B. Detail Use Case Utama: UC-02 (Membuat Laporan Pencemaran)
- **Primary Actor:** Masyarakat / User
- **Pre-condition:** Aplikasi terbuka dan user berada di halaman Form Pelaporan.
- **Main Flow:**
  1. User menekan tombol "Buat Laporan".
  2. Sistem menampilkan Form Pelaporan.
  3. User memilih nama sungai/lokasi, tingkat keparahan (Ringan, Sedang, Berat), dan mengisi deskripsi.
  4. User menekan tombol "Kirim Laporan".
  5. Sistem memvalidasi kelengkapan input data.
  6. Sistem menyimpan data laporan ke database (SQLite) dan memberikan notifikasi sukses.
  7. Sistem mengarahkan user ke Layar Riwayat Laporan.
- **Alternative Flow:** Jika input belum lengkap, sistem menampilkan pesan peringatan error validasi.

---

## 4. Alur Kerja Sistem (Flowchart)

```
[Mulai]
   │
   ▼
[Layar Beranda / Dashboard]
   │
   ├──────► [Lihat Detail & Kondisi Sungai]
   │
   ├──────► [Form Pelaporan Baru]
   │           │
   │           ▼
   │        [Input Lokasi, Keparahan, Deskripsi]
   │           │
   │           ▼
   │        [Validasi Input Data] ──(Tidak Valid)──► [Pesan Error / Lengkapi Form]
   │           │ (Valid)
   │           ▼
   │        [Simpan ke SQLite Database]
   │           │
   │           ▼
   └──────► [Layar Riwayat Laporan]
               │
               ▼
            [Detail & Status Laporan: Pending / Diproses / Selesai]
               │
               ▼
            [Selesai]
```

---

## 5. Daftar Layar dan Antarmuka (Screen & Navigation List)

1. **Layar Splash / Intro (Splash Screen):**
   - Logo SungaiKu dan branding aplikasi RPL USTI Pekanbaru.
2. **Layar Beranda (Dashboard Screen):**
   - Ringkasan statistik (Jumlah Laporan, Sungai Dipantau, Status Selesai).
   - Card daftar sungai terdekat beserta tingkat kebersihan (Baik, Waspada, Bahaya).
3. **Layar Detail Sungai (River Detail Screen):**
   - Detail informasi sungai, lokasi, status debit/sampah, dan riwayat laporan terkait.
4. **Layar Form Pelaporan (Report Form Screen):**
   - Input Nama Sungai / Lokasi.
   - Dropdown / Radio Keparahan (Ringan, Sedang, Berat).
   - Textarea Deskripsi Masalah.
   - Tombol Kirim & Reset.
5. **Layar Riwayat Laporan (Report History Screen):**
   - List view laporan masyarakat.
   - Badge Status (*Pending*, *Diproses*, *Selesai*).
   - Fitur Filter / Search laporan.
6. **Layar Detail Laporan & Admin Status Update (Report Detail Screen):**
   - Tampilan rincian laporan.
   - Tombol simulasi update status oleh Pengelola/Admin.

---

## 6. Arsitektur Struktur Folder Proyek (Flutter Standard)

```
lib/
├── main.dart                   # Entry point aplikasi & inisialisasi tema/route
├── config/
│   └── app_theme.dart          # Tema warna (Teal/Blue - identitas sungai) & gaya teks
├── models/
│   ├── river_model.dart        # Model data sungai
│   └── report_model.dart       # Model data laporan pencemaran
├── services/
│   └── database_helper.dart    # Service SQLite (Sqflite) untuk CRUD lokal
├── providers/
│   └── report_provider.dart    # State management pelaporan & sungai
└── screens/
    ├── home/
    │   ├── home_screen.dart
    │   └── widgets/
    ├── river/
    │   └── river_detail_screen.dart
    ├── report/
    │   ├── report_form_screen.dart
    │   └── report_history_screen.dart
    └── widgets/
        └── custom_badge.dart
```
