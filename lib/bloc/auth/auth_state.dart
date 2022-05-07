part of 'auth_cubit.dart';

@immutable
class AuthState {
  final AuthStatus status;
  final String? error;
  AuthState({
    this.status = AuthStatus.initial,
    this.error,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState && other.status == status && other.error == error;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode;

  AuthState copyWith({
    required AuthStatus? status,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => 'AuthState(status: $status, error: $error)';
}

enum AuthStatus { initial, loading, loggedIn, loggedOut, error }
