import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'email-already-in-use':
          return 'This email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'weak-password':
          return 'Password is too weak';
        case 'network-request-failed':
          return 'Network error. Please check your connection';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        case 'operation-not-allowed':
          return 'Operation not allowed';
        case 'invalid-credential':
          return 'Invalid email or password';
        default:
          return 'Authentication failed. Please try again';
      }
    }
    return 'An error occurred. Please try again';
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(AuthLoggedIn());
    } else {
      emit(AuthLoggedOut());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthLoggedIn());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
      emit(AuthLoggedOut());
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await userCredential.user?.updateDisplayName(event.name);
      emit(AuthLoggedIn());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
      emit(AuthLoggedOut());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _firebaseAuth.signOut();
    emit(AuthLoggedOut());
  }
}
