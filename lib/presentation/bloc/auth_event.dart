abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class AuthFormSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String? name;

  AuthFormSubmitted({required this.email, required this.password, this.name});
}
