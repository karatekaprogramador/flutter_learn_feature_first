import '../services/insforge_auth_service.dart';

export '../services/insforge_auth_service.dart'
    show AuthApiException, AuthOAuthProvider, AuthResult;

class AuthRepository {
  final InsforgeAuthService _authService;

  AuthRepository(this._authService);

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _authService.signInWithEmail(
      email: email,
      password: password,
    );
  }

  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) {
    return _authService.signUpWithEmail(
      email: email,
      password: password,
      name: name,
    );
  }

  Future<void> signInWithOAuth(AuthOAuthProvider provider) {
    return _authService.startOAuth(provider);
  }
}
