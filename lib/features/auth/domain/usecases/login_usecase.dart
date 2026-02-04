import 'package:my_secure_app/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase{
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({required String password, required String correo}) async{
    //validamos
    if(!correo.contains("@")){
        throw Exception("Error, el correo no es válido");
    }
    
    if (password.isEmpty) {
      throw Exception("Error, la contraseña está vacía");
    }
    
    final repository_login = await repository.login(correo, password);

    return repository_login;
  }
}

