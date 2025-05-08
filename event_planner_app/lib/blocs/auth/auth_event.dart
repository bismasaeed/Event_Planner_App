// lib/blocs/auth/auth_event.dart
abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {}

class LoggedOut extends AuthEvent {}
