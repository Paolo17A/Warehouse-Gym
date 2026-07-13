import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState.initial() = Initial;
  const factory ForgotPasswordState.submitting() = Submitting;
  const factory ForgotPasswordState.failed(Failure failure) = Failed;
  const factory ForgotPasswordState.success() = Success;
}

extension ForgotPasswordStateX on ForgotPasswordState {
  bool get isSubmitting => this is Submitting;

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );
}
