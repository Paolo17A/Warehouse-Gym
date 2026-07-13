import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/usecases/auth_usecase.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/forgot_password/forgot_password_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'forgot_password_state.dart';

class ForgotPasswordViewModel extends StateNotifier<ForgotPasswordState> {
  final AuthUseCase _auth;

  ForgotPasswordViewModel({required AuthUseCase auth})
      : _auth = auth,
        super(const ForgotPasswordState.initial());

  Future<void> forgotPassword(String email) async {
    state = const ForgotPasswordState.submitting();
    final result = await _auth.forgotPassword(email);
    result.fold(
      (failure) => state = ForgotPasswordState.failed(failure),
      (_) => state = const ForgotPasswordState.success(),
    );
  }
}

final forgotPasswordViewModelProvider =
    StateNotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>((_) {
  return ForgotPasswordViewModel(auth: sl<AuthUseCase>());
});
