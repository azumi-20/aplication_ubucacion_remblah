import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource(this.firebaseAuth);

  Future<UserCredential> registro(String correo, String password) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: correo,
      password: password,
    );
  }

  Future<UserCredential> login(String correo, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: correo,
      password: password,
    );
  }
}
