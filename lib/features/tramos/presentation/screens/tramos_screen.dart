import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/tramo_card.dart';
import '../../models/tramo_model.dart';
import 'tramo_detail_screen.dart';

class TramosScreen extends StatelessWidget {
  const TramosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tramos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFE8F5E9),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_done_outlined, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Contenido disponible sin conexión",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tramo')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No hay tramos disponibles"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final tramo = TramoModel(
                      id: data['id']?.toString() ?? docs[index].id,
                      nombre: data['nombre'] ?? 'Sin nombre',
                      distancia: data['distancia'] ?? '0 km',
                      dificultad: data['dificultad'] ?? 'N/A',
                      tiempo: data['tiempo'] ?? '--',
                      imagenUrl:
                          (data['imagen_url'] != null &&
                              data['imagen_url'].toString().isNotEmpty)
                          ? data['imagen_url']
                          : 'https://via.placeholder.com/300',
                    );

                    return TramoCard(
                      tramo: tramo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TramoDetailScreen(tramo: tramo),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
