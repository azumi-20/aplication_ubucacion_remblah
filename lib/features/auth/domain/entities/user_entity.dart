class UserEntity {
  final String uid;
  final String nombre;
  final String correo;
  final String password;

  //metodo acceso
  UserEntity({
    required this.correo,
    required this.nombre,
    required this.password,
    required this.uid,
  });
}

/*
definición pura de negocio, solo datos, no importa de dónde vienen.

Model → generalmente mapea datos externos (de la DB, Firebase o un JSON) a tu Entity.
*/