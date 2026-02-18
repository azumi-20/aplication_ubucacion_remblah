import 'package:flutter/material.dart';
import 'register_page.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color verdeCorporativo = Color(0xFF3A5F0B);
    const Color fondoArena = Color(0xFFF5F5DC);
    const Color botonOscuro = Color(0xFF2D2D2D);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: fondoArena,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.terrain_rounded,
                    size: size.height * 0.15,
                    color: verdeCorporativo,
                  ),

                  SizedBox(height: size.height * 0.03),

                  Text(
                    "Camino de los Sueños",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.08,
                      fontWeight: FontWeight.bold,
                      color: verdeCorporativo,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Guía Viva del Turismo Rural\nComunitario y Sostenible.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[700],
                      height: 1.4,
                    ),
                  ),

                  // esspacio dinámico entre el texto y los botones
                  SizedBox(height: size.height * 0.1),

                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: botonOscuro,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "INICIAR SESIÓN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: verdeCorporativo,
                      side: const BorderSide(color: verdeCorporativo, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "CREAR CUENTA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Explorar como invitado",
                      style: TextStyle(
                        color: Colors.brown[600],
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
