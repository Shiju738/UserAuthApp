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
    on<AuthFormSubmitted>(_onAuthFormSubmitted);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(AuthLoggedIn());
    } else {
      emit(AuthLoggedOut());
    }
  }

  Future<void> _onAuthFormSubmitted(
    AuthFormSubmitted event,
    Emitter<AuthState> emit,
  ) async {}
}
