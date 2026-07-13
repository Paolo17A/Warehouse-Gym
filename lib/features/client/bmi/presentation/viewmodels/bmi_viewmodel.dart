import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/core/utils/toast_utils.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/entities/bmi_entry.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/usecases/bmi_usecase.dart';
import 'package:the_warehouse_gym/features/client/bmi/presentation/viewmodels/bmi_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'bmi_state.dart';

class BmiViewModel extends StateNotifier<BmiState> {
  final BmiUseCase _bmi;

  BmiViewModel({required BmiUseCase bmi})
      : _bmi = bmi,
        super(const BmiState.initial());

  Future<void> loadHistory(String uid) async {
    _setLoadingState();
    final result = await _bmi.getBmiHistory(uid);
    result.fold(
      (failure) {
        state = BmiState.failed(failure);
        showFailureToast(failure);
      },
      (entries) => state = BmiState.loaded(entries),
    );
  }

  Future<bool> addEntry(
    String uid,
    double bmiValue, {
    required double heightCm,
    required double weightKg,
  }) async {
    final previousEntries = _currentEntries();
    final entry = BmiEntry(dateTime: DateTime.now(), bmiValue: bmiValue);
    state = BmiState.submitting(previousEntries);

    final result = await _bmi.addBmiEntry(
      uid,
      entry,
      heightCm: heightCm,
      weightKg: weightKg,
    );
    return await result.fold(
      (failure) async {
        state = BmiState.loaded(previousEntries);
        showFailureToast(failure);
        return false;
      },
      (_) async {
        await loadHistory(uid);
        return true;
      },
    );
  }

  Future<void> refresh(String uid) => loadHistory(uid);

  List<BmiEntry> _currentEntries() => state.maybeMap(
        loaded: (value) => value.entries,
        submitting: (value) => value.entries,
        refreshing: (value) => value.entries,
        orElse: () => const [],
      );

  void _setLoadingState() {
    final entries = _currentEntries();
    if (entries.isNotEmpty) {
      state = BmiState.refreshing(entries);
      return;
    }
    state = const BmiState.loading();
  }
}

final bmiViewModelProvider = StateNotifierProvider<BmiViewModel, BmiState>(
  (_) => BmiViewModel(bmi: sl<BmiUseCase>()),
);
