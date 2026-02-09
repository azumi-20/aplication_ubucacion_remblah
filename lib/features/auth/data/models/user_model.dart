import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String uid,
    required String nombre,
    required String correo,
  }) : super(
         uid: uid,
         nombre: nombre,
         correo: correo,
         password: '',
       );

  /// Crear desde Firebase Auth (SIN Firestore)
  factory UserModel.fromFirebaseAuth({
    required String uid,
    required String correo,
    String? nombre,
  }) {
    return UserModel(
      uid: uid,
      nombre: nombre ?? '',
      correo: correo,
    );
  }
}
