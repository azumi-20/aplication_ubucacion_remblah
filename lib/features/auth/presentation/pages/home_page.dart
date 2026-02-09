// de prueba, no se muestra en la app, es para probar el home

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color verdeCorporativo = Color(0xFF3A5F0B);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: verdeCorporativo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: verdeCorporativo,
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Inicio de sesión exitoso!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: verdeCorporativo,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bienvenido a Camino de los Sueños',
              style: TextStyle(fontSize: 16, color: Colors.brown),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verdeCorporativo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              onPressed: () {},
              child: const Text('Explorar Sueños'),
            ),
          ],
        ),
      ),
    );
  }
}
