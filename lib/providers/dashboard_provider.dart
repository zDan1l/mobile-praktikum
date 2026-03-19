import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  int _mahasiswa = 120;
  int _dosen = 30;
  int _matakuliah = 45;

  int get mahasiswa => _mahasiswa;
  int get dosen => _dosen;
  int get matakuliah => _matakuliah;

  void tambahMahasiswa() {
    _mahasiswa++;
    notifyListeners();
  }

  void tambahDosen() {
    _dosen++;
    notifyListeners();
  }

  void tambahMatakuliah() {
    _matakuliah++;
    notifyListeners();
  }
}
