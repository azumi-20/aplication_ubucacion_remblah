import 'package:my_secure_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_secure_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase{

  LoginUseCase(this.repository);
  final AuthRepository repository;

  Future<UserEntity> call({required String password, required String correo}) async{
    //validamos
    if(!correo.contains('@')){
        throw Exception('Error, el correo no es válido');
    }
    
    if (password.isEmpty) {
      throw Exception('Error, la contraseña está vacía');
    }
    
    final repositoryLogin = await repository.login(correo, password);

    return repositoryLogin;
  }
}

