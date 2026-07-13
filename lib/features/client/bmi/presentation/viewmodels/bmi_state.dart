import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/client/bmi/domain/entities/bmi_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bmi_state.freezed.dart';

@freezed
class BmiState with _$BmiState {
  const factory BmiState.initial() = Initial;
  const factory BmiState.loading() = Loading;
  const factory BmiState.refreshing(List<BmiEntry> entries) = Refreshing;
  const factory BmiState.loaded(List<BmiEntry> entries) = Loaded;
  const factory BmiState.submitting(List<BmiEntry> entries) = Submitting;
  const factory BmiState.failed(Failure failure) = Failed;
}

extension BmiStateX on BmiState {
  bool get isLoading => this is Loading || this is Refreshing;

  bool get isSubmitting => this is Submitting;

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );

  List<BmiEntry> get entries => maybeMap(
        loaded: (value) => value.entries,
        submitting: (value) => value.entries,
        refreshing: (value) => value.entries,
        orElse: () => const [],
      );
}
