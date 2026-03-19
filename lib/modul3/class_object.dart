import 'dart:io';

class Mahasiswa {
  String? nama;
  int? nim;
  void tampilkanData() {
    print("Nama : ${nama ?? 'Belum diisi'}");
    print("Nim : ${nim ?? 'Belum diisi'}");
  }
}

class MahasiswaAktif extends Mahasiswa {
  int? semester;

  void tampilkanDataAktif() {
    tampilkanData();
    print("Semester : ${semester ?? 'Belum diisi'}");
  }
}

class MahasiswaAlumni extends Mahasiswa {
  int? tahunLulus;

  void tampilkanDataAlumni() {
    tampilkanData();
    print("Tahun Lulus : ${tahunLulus ?? 'Belum diisi'}");
  }
}

mixin Pengajaran {
  List<String> mataKuliah = [];

  void tambahMataKuliah(String mk) {
    mataKuliah.add(mk);
    print("Mata kuliah '$mk' berhasil ditambahkan");
  }

  void tampilkanMataKuliah() {
    print("Daftar Mata Kuliah:");
    if (mataKuliah.isEmpty) {
      print("  - Belum ada mata kuliah");
    } else {
      for (var mk in mataKuliah) {
        print("  - $mk");
      }
    }
  }
}

mixin Penelitian {
  List<String> proyekPenelitian = [];

  void tambahProyek(String proyek) {
    proyekPenelitian.add(proyek);
    print("Proyek penelitian '$proyek' berhasil ditambahkan");
  }

  void tampilkanProyek() {
    print("Daftar Proyek Penelitian:");
    if (proyekPenelitian.isEmpty) {
      print("  - Belum ada proyek penelitian");
    } else {
      for (var proyek in proyekPenelitian) {
        print("  - $proyek");
      }
    }
  }
}

mixin Administrasi {
  String? ruangKerja;

  void aturRuangKerja(String ruang) {
    ruangKerja = ruang;
    print("Ruang kerja diatur ke: $ruang");
  }

  void tampilkanInfoAdministrasi() {
    print("Informasi Administrasi:");
    print("  Ruang Kerja: ${ruangKerja ?? 'Belum ditentukan'}");
  }
}

class Dosen extends Mahasiswa with Pengajaran, Penelitian, Administrasi {
  String? nip;

  void tampilkanDataDosen() {
    tampilkanData();
    print("NIP : ${nip ?? 'Belum diisi'}");
  }
}

class Fakultas extends Mahasiswa with Pengajaran, Administrasi {
  String? namaFakultas;

  void tampilkanDataFakultas() {
    tampilkanData();
    print("Nama Fakultas : ${namaFakultas ?? 'Belum diisi'}");
  }
}

void main() {
  print("\n\n=== DATA DOSEN (WITH MIXIN) ===");
  Dosen dosen = Dosen();
  print("Masukkan nama Dosen: ");
  dosen.nama = stdin.readLineSync();
  print("Masukkan NIP: ");
  dosen.nip = stdin.readLineSync();
  print("Masukkan Ruang Kerja: ");
  String? ruang = stdin.readLineSync();
  if (ruang != null && ruang.isNotEmpty) {
    dosen.aturRuangKerja(ruang);
  }

  print("\nTambahkan Mata Kuliah (ketik 'selesai' untuk berhenti):");
  while (true) {
    String? mk = stdin.readLineSync();
    if (mk == null || mk.toLowerCase() == 'selesai') break;
    dosen.tambahMataKuliah(mk);
  }

  print("\nTambahkan Proyek Penelitian (ketik 'selesai' untuk berhenti):");
  while (true) {
    String? proyek = stdin.readLineSync();
    if (proyek == null || proyek.toLowerCase() == 'selesai') break;
    dosen.tambahProyek(proyek);
  }

  print("\n--- Tampilan Data Dosen ---");
  dosen.tampilkanDataDosen();
  dosen.tampilkanInfoAdministrasi();
  dosen.tampilkanMataKuliah();
  dosen.tampilkanProyek();

  print("\n\n=== DATA FAKULTAS (WITH MIXIN) ===");
  Fakultas fakultas = Fakultas();
  print("Masukkan nama Fakultas: ");
  fakultas.namaFakultas = stdin.readLineSync();
  print("Masukkan Ruang Kerja Dekanat: ");
  String? ruangFakultas = stdin.readLineSync();
  if (ruangFakultas != null && ruangFakultas.isNotEmpty) {
    fakultas.aturRuangKerja(ruangFakultas);
  }

  print("\nTambahkan Program Studi (ketik 'selesai' untuk berhenti):");
  while (true) {
    String? prodi = stdin.readLineSync();
    if (prodi == null || prodi.toLowerCase() == 'selesai') break;
    fakultas.tambahMataKuliah(prodi);
  }

  print("\n--- Tampilan Data Fakultas ---");
  fakultas.tampilkanDataFakultas();
  fakultas.tampilkanInfoAdministrasi();
  fakultas.tampilkanMataKuliah();
}
