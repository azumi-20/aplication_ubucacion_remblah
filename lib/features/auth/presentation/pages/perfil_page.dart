import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'welcome_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  //para notificaciones, lo ideal sería usar un provider o bloc para manejar el estado globalmente, pero por simplicidad lo dejo aquí como variable local
  bool _notificationsEnabled = true;

  Future<void> _imgFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _imgFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Elegir de Galería'),
                onTap: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Colors.green),
                title: const Text('Tomar Foto'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    //bloqueo para invitados
    if (user == null || user.isAnonymous) {
      return _buildGuestView(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil de Usuario"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF3A5F0B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //header avayar y nombre del usuario
            Container(
              width: double.infinity,
              color: const Color(0xFF3A5F0B),
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showPicker(context),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : null,
                          child: _image == null
                              ? const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Color(0xFF3A5F0B),
                                )
                              : null,
                        ),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user.displayName ?? "Explorador REMBLAH",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Miembro desde 2026",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            //estadisticas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(Icons.route, "0", "Tramos"),
                      _buildStatItem(Icons.location_on, "0", "Hitos"),
                      _buildStatItem(
                        Icons.directions_walk,
                        "0 km",
                        "Recorrido",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //configuración
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8),
                    child: Text(
                      "CONFIGURACIÓN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  _buildNotificationTile(),
                  _buildListTile(
                    Icons.language,
                    "Idioma",
                    trailingText: "Español",
                  ),
                  _buildListTile(
                    Icons.cloud_done_outlined,
                    "Contenido Offline",
                    trailingText: "Activado",
                  ),
                  _buildListTile(Icons.security, "Privacidad y Datos"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //cerrar sesión
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  "CERRAR SESIÓN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              "REMBLAH - CAMINO DE LOS SUEÑOS App v1.0.0",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // widgets auxiliares para construir los elementos de la interfaz de usuario de forma más ordenada
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF3A5F0B), size: 30),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildNotificationTile() {
    return ListTile(
      leading: const Icon(
        Icons.notifications_active_outlined,
        color: Colors.green,
      ),
      title: const Text("Notificaciones"),
      subtitle: Text(_notificationsEnabled ? "Activadas" : "Desactivadas"),
      trailing: Switch(
        value: _notificationsEnabled,
        activeColor: Colors.green,
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value ? "Alertas habilitadas" : "Alertas silenciadas",
              ),
              backgroundColor: value ? Colors.green : Colors.black87,
              duration: const Duration(milliseconds: 800),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {String? trailingText}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle_outlined,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                "Modo Invitado",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Inicia sesión para personalizar tu perfil y guardar tus recorridos en Camino de los sueños.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A5F0B),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  "Iniciar Sesión ahora",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
