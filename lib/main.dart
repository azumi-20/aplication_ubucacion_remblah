/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // generado por flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Test',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase inicializado'),
        ),
        body: Center(
          child: Text(
            'Firebase está listo para usar 🟢',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_secure_app/features/auth/presentation/pages/welcome_page.dart';
import 'firebase_options.dart';

import 'package:my_secure_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_secure_app/features/auth/data/datasources/firebase_auth_datasource.dart';

import 'package:my_secure_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_secure_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_secure_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_secure_app/features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inyeccion del bloc

  final authDataSource = FirebaseAuthDatasource();

  final authRepository = AuthRepositoryImpl(datasource: authDataSource);

  final loginUC = LoginUseCase(authRepository);
  final registerUC = RegisterUseCase(authRepository);

  runApp(
    //Bloc para toda la app
    BlocProvider(
      create: (context) => AuthBloc(
        loginUseCase: loginUC,
        registerUseCase: registerUC,
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
      title: 'Turismo Rural - Camino de los Sueños',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF3A5F0B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A5F0B),
          primary: const Color(0xFF3A5F0B),
          secondary: const Color(0xFF6F4E37),
          surface: const Color(0xFFF5F5DC),
        ),

        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF3A5F0B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      home: const WelcomePage(),
    );
  }
}
