import '../models/dosen_model.dart';
import 'package:dio/dio.dart';

class DosenRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    headers: {'Accept': 'application/json'},
  ));

  /// Mendapatkan daftar dosen menggunakan package Dio
  Future<List<DosenModel>> getDosenList() async {
    try {
      final response = await _dio.get('/users');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => DosenModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data dosen: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }
}
