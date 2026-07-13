import 'package:the_warehouse_gym/core/di/injection.dart';
import 'package:the_warehouse_gym/features/shared/auth/domain/usecases/auth_usecase.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/login/auth_redirect_resolver.dart';
import 'package:the_warehouse_gym/features/shared/auth/presentation/login/sign_in_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'sign_in_state.dart';

class SignInViewModel extends StateNotifier<SignInState> {
  final AuthUseCase _auth;

  SignInViewModel({required AuthUseCase auth})
      : _auth = auth,
        super(const SignInState.initial());

  Future<void> signIn(String email, String password) async {
    state = const SignInState.submitting();
    final result = await _auth.signIn(email, password);
    result.fold(
      (failure) => state = SignInState.failed(failure),
      (user) => state = SignInState.authenticated(
        user,
        resolveAuthRedirect(user),
      ),
    );
  }

  void clearRedirect() {
    state = const SignInState.initial();
  }
}

final signInViewModelProvider =
    StateNotifierProvider<SignInViewModel, SignInState>((_) {
  return SignInViewModel(auth: sl<AuthUseCase>());
});
