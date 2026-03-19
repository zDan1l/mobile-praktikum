import '../models/mahasiswa_aktif_model.dart';
import 'package:dio/dio.dart';

class MahasiswaAktifRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    headers: {'Accept': 'application/json'},
  ));

  /// Mendapatkan daftar mahasiswa aktif menggunakan package Dio
  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    try {
      final response = await _dio.get('/posts');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MahasiswaAktifModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data mahasiswa aktif: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }
}
