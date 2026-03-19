import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dosen_model.dart';
import '../../data/repositories/dosen_repository.dart';

// Repository Provider
final dosenRepositoryProvider = Provider<DosenRepository>((ref) {
  return DosenRepository();
}); // Provider

// StateNotifier untuk mengelola state dosen
class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;

  DosenNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDosenList();
  }

  /// Load data dosen dalam bentuk list
  Future<void> loadDosenList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDosenList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh data dosen dalam bentuk list
  Future<void> refresh() async {
    await loadDosenList();
  }
}

// Dosen Notifier Provider
final dosenNotifierProvider =
    StateNotifierProvider.autoDispose<
      DosenNotifier,
      AsyncValue<List<DosenModel>>
    >((ref) {
      final repository = ref.watch(dosenRepositoryProvider);
      return DosenNotifier(repository);
    });
