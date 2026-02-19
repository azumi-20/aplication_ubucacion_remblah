import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<UserEntity> registro(
    String nombre,
    String correo,
    String password,
  ) async {
    final firebaseUser = await datasource.registrarUsuario(
      correo: correo,
      password: password,
    );

    //NO Firestore
    await datasource.enviarEmailVerificacion(firebaseUser);

    return UserModel.fromFirebaseAuth(
      uid: firebaseUser.uid,
      correo: firebaseUser.email ?? correo,
      nombre: nombre,
    );
  }

  @override
  Future<UserEntity> login(String correo, String password) async {
    final firebaseUser = await datasource.iniciarSesion(
      correo: correo,
      password: password,
    );

    //NO Firestore
    return UserModel.fromFirebaseAuth(
      uid: firebaseUser.uid,
      correo: firebaseUser.email ?? correo,
      nombre: firebaseUser.displayName,
    );
  }

  @override
  Future<void> logout() async {
    await datasource.cerrarSesion();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = datasource.obtenerUsuarioActual();

    if (firebaseUser == null) return null;

    return UserModel.fromFirebaseAuth(
      uid: firebaseUser.uid,
      correo: firebaseUser.email ?? '',
      nombre: firebaseUser.displayName,
    );
  }
}
