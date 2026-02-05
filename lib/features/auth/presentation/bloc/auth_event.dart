abstract class AuthEvent {}

class AuthRegisterSubmitted extends AuthEvent {
  AuthRegisterSubmitted({
    required this.nombre,
    required this.correo,
    required this.password,
  });

  final String nombre;
  final String correo;
  final String password;
}

class AuthLoginSubmitted extends AuthEvent {
  AuthLoginSubmitted({
    required this.correo,
    required this.password,
  });

  final String correo;
  final String password;
}
