import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mahasiswa_model.dart';
import '../../data/repositories/mahasiswa_repository.dart';

// Repository Provider
final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return MahasiswaRepository();
});

// StateNotifier untuk mengelola state mahasiswa
class MahasiswaNotifier extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;

  MahasiswaNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMahasiswaList();
  }

  /// Load data mahasiswa dalam bentuk list
  Future<void> loadMahasiswaList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh data mahasiswa dalam bentuk list
  Future<void> refresh() async {
    await loadMahasiswaList();
  }
}

// Mahasiswa Notifier Provider
final mahasiswaNotifierProvider =
    StateNotifierProvider.autoDispose<
      MahasiswaNotifier,
      AsyncValue<List<MahasiswaModel>>
    >((ref) {
      final repository = ref.watch(mahasiswaRepositoryProvider);
      return MahasiswaNotifier(repository);
    });
