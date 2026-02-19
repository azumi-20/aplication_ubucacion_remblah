import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registrar usuario en Firebase Auth
  Future<User> registrarUsuario({
    required String correo,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: correo,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Error al crear usuario');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _manejarErrorAuth(e);
    }
  }

  /// Iniciar sesión
  Future<User> iniciarSesion({
    required String correo,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: correo,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Error al iniciar sesión');
      }

      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      throw _manejarErrorAuth(e);
    }
  }

  /// Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  /// Obtener usuario actual
  User? obtenerUsuarioActual() {
    return _auth.currentUser;
  }

  /// Enviar email de verificación
  Future<void> enviarEmailVerificacion(User user) async {
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception('Error al enviar email: ${e.message}');
    }
  }

  /// Manejo de errores de Firebase Auth
  Exception _manejarErrorAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('Este correo ya está registrado');
      case 'weak-password':
        return Exception('La contraseña es demasiado débil');
      case 'invalid-email':
        return Exception('El correo no es válido');
      case 'user-not-found':
        return Exception('Usuario no encontrado');
      case 'wrong-password':
        return Exception('Contraseña incorrecta');
      case 'user-disabled':
        return Exception('Usuario deshabilitado');
      case 'too-many-requests':
        return Exception('Demasiados intentos. Intenta más tarde');
      case 'operation-not-allowed':
        return Exception('Operación no permitida');
      case 'network-request-failed':
        return Exception('Error de conexión. Verifica tu internet');
      default:
      return Exception('Firebase Auth error: ${e.code} - ${e.message}');

    }
  }
}
