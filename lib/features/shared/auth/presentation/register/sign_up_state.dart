import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = Initial;
  const factory SignUpState.submitting() = Submitting;
  const factory SignUpState.failed(Failure failure) = Failed;
  const factory SignUpState.success() = Success;
}

extension SignUpStateX on SignUpState {
  bool get isSubmitting => this is Submitting;

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );
}
