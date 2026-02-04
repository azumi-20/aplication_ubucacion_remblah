import 'package:my_secure_app/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';


class RegisterUseCase {
    //recibe una interfaz
    final AuthRepository repository;

    //construccion
    RegisterUseCase( this.repository);

    //funcion principal call
    Future<UserEntity> call({required String nombre, required String correo,required String password,}) async{
      //validamos
      if(nombre.isEmpty){
        throw Exception("Error, el nombre está vacío");
      }

      if(!correo.contains("@")){
        throw Exception("Error, el correo no es válido");
      }

      if(password.length < 8){
         throw Exception("Error, la contraseña es muy corta");
      }

        // Llamada al repositorio
        final repositorio_registro = await repository.registro(nombre, correo, password);

      // Retornamos UserEntity
      return repositorio_registro;
    }

}

/*
call: Es el método principal del UseCase
*/