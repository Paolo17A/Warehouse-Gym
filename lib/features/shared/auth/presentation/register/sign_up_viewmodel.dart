import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/usecases/auth_usecase.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/register/sign_up_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'sign_up_state.dart';

class SignUpViewModel extends StateNotifier<SignUpState> {
  final AuthUseCase _auth;

  SignUpViewModel({required AuthUseCase auth})
      : _auth = auth,
        super(const SignUpState.initial());

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = const SignUpState.submitting();
    final result = await _auth.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => state = SignUpState.failed(failure),
      (_) => state = const SignUpState.success(),
    );
  }
}

final signUpViewModelProvider =
    StateNotifierProvider<SignUpViewModel, SignUpState>((_) {
  return SignUpViewModel(auth: sl<AuthUseCase>());
});
