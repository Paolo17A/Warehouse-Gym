import 'package:the_warehouse_gym/core/errors/failures.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/entities/app_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

@freezed
class SignInState with _$SignInState {
  const factory SignInState.initial() = Initial;
  const factory SignInState.submitting() = Submitting;
  const factory SignInState.failed(Failure failure) = Failed;
  const factory SignInState.authenticated(
    AppUser user,
    String redirectPath,
  ) = Authenticated;
}

extension SignInStateX on SignInState {
  bool get isSubmitting => this is Submitting;

  Failure? get failure => maybeMap(
        failed: (value) => value.failure,
        orElse: () => null,
      );

  String? get redirectPath => maybeMap(
        authenticated: (value) => value.redirectPath,
        orElse: () => null,
      );
}
