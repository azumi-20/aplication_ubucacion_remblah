import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_secure_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_secure_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_secure_app/features/auth/presentation/bloc/auth_state.dart';
import 'register_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final Color _verdeCorporativo = const Color(0xFF3A5F0B);
  final Color _fondoArena = const Color(0xFFF5F5DC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoArena,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('¡Bienvenido de nuevo!'),
                backgroundColor: _verdeCorporativo,
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Bienvenido",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _verdeCorporativo,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Ingresa para continuar el recorrido.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF5D4037), fontSize: 16),
                ),
                const SizedBox(height: 40),
                _buildTabs(),
                const SizedBox(height: 32),
                _buildField("Correo electrónico", _emailController, false),
                const SizedBox(height: 20),
                _buildField("Contraseña", _passwordController, true),
                const SizedBox(height: 40),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AuthLoading ? null : _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _verdeCorporativo,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: state is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "CONTINUAR",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                "Iniciar Sesión",
                style: TextStyle(
                  color: _verdeCorporativo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: _verdeCorporativo, thickness: 3),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            ),
            child: Column(
              children: [
                Text("Registro", style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                Divider(color: Colors.grey[300], thickness: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    bool isPass,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6F4E37),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPass,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: _verdeCorporativo, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginSubmitted(
          correo: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }
}
