/*import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Login App')),
        body: const Center(child: Text('Hola, Flutter Web!')),
      ),
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_secure_app/features/auth/presentation/pages/welcome_home.dart';
//para probar pantallas de inicio de sesión y registro
import 'package:my_secure_app/features/auth/presentation/pages/welcome_home.dart';
import 'package:my_secure_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_secure_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_secure_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_secure_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_secure_app/features/auth/domain/entities/user_entity.dart';

//repositorio mock (para pruebas)
class AuthRepositoryMock implements AuthRepository {
  @override
  Future<UserEntity> registro(
    String nombre,
    String correo,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserEntity(
      uid: '123',
      nombre: nombre,
      correo: correo,
      password: password,
      id: '',
    );
  }

  @override
  Future<UserEntity> login(String correo, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserEntity(
      uid: '123',
      nombre: 'Usuario Prueba',
      correo: correo,
      password: password,
      id: '',
    );
  }
}

void main() {
  //inicializamos el repositorio mock o depencias
  final authRepository = AuthRepositoryMock();
  final registerUC = RegisterUseCase(authRepository);
  final loginUC = LoginUseCase(authRepository);

  runApp(
    //se envuelve MyApp (toda la app) con el BlocProvider
    BlocProvider(
      create: (context) => AuthBloc(
        registerUseCase: registerUC,
        loginUseCase: loginUC,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camino de los Sueños',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF00C853),
      ),
      // honme
      home: const WelcomePage(),
    );
  }
}
