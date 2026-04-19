import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class AuthState {
  const AuthState();
  bool get isAuthenticated => this is Authenticated;
  String? get error => this is AuthError ? (this as AuthError).message : null;
  bool get isLoading => this is AuthLoading;
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final String email;
  const Authenticated(this.email);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const Unauthenticated());

  Future<bool> login(String email, String password) async {
    state = const AuthLoading();
    
    // Simulating API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'admin@hostel.com' && password == 'admin123') {
      state = Authenticated(email);
      return true;
    } else {
      state = const AuthError('Invalid email or password');
      return false;
    }
  }

  void logout() {
    state = const Unauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
