import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modul_3/core/services/local_storage_service.dart';
import 'package:modul_3/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:modul_3/features/mahasiswa/data/repositories/mahasiswa_repository.dart';

// Repository Provider
final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return MahasiswaRepository();
});

// LocalStorageService Provider
final mahasiswaStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

// — Provider semua data user yang disimpan ——————————
final savedMahasiswasProvider =
    FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(mahasiswaStorageServiceProvider);
  return storage.getSavedUsers();
});

// Provider untuk membaca saved user dari local storage
final savedMahasiswaProvider = FutureProvider<Map<String, String?>>((ref) async {
  final storage = ref.watch(mahasiswaStorageServiceProvider);
  final userId = await storage.getUserId();
  final username = await storage.getUsername();
  final token = await storage.getToken();
  return {'userId': userId, 'username': username, 'token': token};
});

// StateNotifier untuk mengelola state mahasiswa
class MahasiswaNotifier extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;
  final LocalStorageService _storage;

  MahasiswaNotifier(this._repository, this._storage)
      : super(const AsyncValue.loading()) {
    loadMahasiswaList();
  }

  Future<void> loadMahasiswaList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadMahasiswaList();
  }

  /// Simpan mahasiswa yang dipilih ke local storage (tanpa menghapus yang lama)
  Future<void> saveSelectedMahasiswa(MahasiswaModel mahasiswa) async {
    await _storage.addUserToSavedList(
      userId: mahasiswa.id.toString(),
      username: mahasiswa.name,
    );
  }

  /// Hapus user tertentu dari list
  Future<void> removeSavedMahasiswa(String userId) async {
    await _storage.removeSavedUser(userId);
  }

  /// Hapus semua user dari list
  Future<void> clearSavedMahasiswas() async {
    await _storage.clearSavedUsers();
  }
}

// Mahasiswa Notifier Provider
final mahasiswaNotifierProvider = StateNotifierProvider.autoDispose<MahasiswaNotifier,
    AsyncValue<List<MahasiswaModel>>>((ref) {
  final repository = ref.watch(mahasiswaRepositoryProvider);
  final storage = ref.watch(mahasiswaStorageServiceProvider);
  return MahasiswaNotifier(repository, storage);
});
