import 'package:equatable/equatable.dart';

enum AuthMode { signIn, signUp }

enum AuthStatus { initial, loading, success, error }

class AuthState extends Equatable {
  final AuthMode mode;
  final AuthStatus status;
  final String? message;
  final bool isAuthenticated;
  final String? accessToken;

  const AuthState({
    this.mode = AuthMode.signIn,
    this.status = AuthStatus.initial,
    this.message,
    this.isAuthenticated = false,
    this.accessToken,
  });

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthMode? mode,
    AuthStatus? status,
    String? message,
    bool? isAuthenticated,
    String? accessToken,
    bool clearMessage = false,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  List<Object?> get props =>
      [mode, status, message, isAuthenticated, accessToken];
}
