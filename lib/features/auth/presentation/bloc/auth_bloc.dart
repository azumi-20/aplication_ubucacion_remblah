import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_secure_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:my_secure_app/features/auth/domain/usecases/register_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
  }) : super(AuthInitial()) {
    on<AuthRegisterSubmitted>(_onRegisterSubmitted);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
  }

  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;

  Future<void> _onRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await registerUseCase.call(
        nombre: event.nombre,
        correo: event.correo,
        password: event.password,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(
        AuthFailure(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await loginUseCase.call(
        correo: event.correo,
        password: event.password,
      );
      emit(AuthSuccess());
    } catch (e) {
      emit(
        AuthFailure(
          e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
