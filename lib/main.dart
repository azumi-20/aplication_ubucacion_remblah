import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_secure_app/features/home/presentation/screens/home_screen.dart';

import 'firebase_options.dart';

import 'package:my_secure_app/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:my_secure_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_secure_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_secure_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_secure_app/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:my_secure_app/features/auth/presentation/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authDataSource = FirebaseAuthDatasource();
  final authRepository = AuthRepositoryImpl(
    datasource: authDataSource,
  );

  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);

  runApp(
    ProviderScope(
      child: BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(
          loginUseCase: loginUseCase,
          registerUseCase: registerUseCase,
        ),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camino de los Sueños',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF3A5F0B),
        scaffoldBackgroundColor: const Color(0xFFF5F5DC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A5F0B),
          primary: const Color(0xFF3A5F0B),
          surface: const Color(0xFFF5F5DC),
        ),
      ),
      home: const WelcomePage(),
    );
  }
}
