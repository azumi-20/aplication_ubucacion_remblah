import 'package:my_secure_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {

  //funcion de registro
  Future<UserEntity> registro(String nombre, String correo, String password);

  //funcion de login
  Future<UserEntity> login(String correo, String password);

}