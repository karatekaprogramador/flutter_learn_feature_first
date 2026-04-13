import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState());

  void toggleMode() {
    emit(
      state.copyWith(
        mode: state.mode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn,
        status: AuthStatus.initial,
        clearMessage: true,
      ),
    );
  }

  Future<void> submit({
    required String email,
    required String password,
    String? name,
  }) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        isAuthenticated: false,
        clearMessage: true,
      ),
    );

    try {
      final result = state.mode == AuthMode.signIn
          ? await _authRepository.signInWithEmail(
              email: email,
              password: password,
            )
          : await _authRepository.signUpWithEmail(
              email: email,
              password: password,
              name: name,
            );

      emit(
        state.copyWith(
          status: AuthStatus.success,
          message: result.message,
          isAuthenticated: true,
        ),
      );
    } on AuthApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: e.message,
          isAuthenticated: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'Ocurrió un error inesperado.',
          isAuthenticated: false,
        ),
      );
    }
  }

  Future<void> signInWithOAuth(AuthOAuthProvider provider) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        isAuthenticated: false,
        clearMessage: true,
      ),
    );

    try {
      await _authRepository.signInWithOAuth(provider);
      emit(
        state.copyWith(
          status: AuthStatus.success,
          message:
              'Continúa el proceso en el navegador y vuelve a la app al finalizar.',
          isAuthenticated: false,
        ),
      );
    } on AuthApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: e.message,
          isAuthenticated: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: 'No se pudo iniciar OAuth.',
          isAuthenticated: false,
        ),
      );
    }
  }
}
