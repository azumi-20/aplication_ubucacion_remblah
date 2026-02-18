import 'package:flutter/material.dart';
import '../../models/tramo_model.dart';

class TramoDetailScreen extends StatelessWidget {
  final TramoModel tramo;

  const TramoDetailScreen({super.key, required this.tramo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //imahen del tramo, con un botón de volver atrás y el título del tramo (imagen al azar por ahora)
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                tramo.imagenUrl,
                fit: BoxFit.cover,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tramo.nombre,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A5F0B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Disponible",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  //características del tramo: distancia, tiempo estimado, dificultad (fácil, media, difícil)
                  Row(
                    children: [
                      _buildDetailIcon(Icons.straighten, tramo.distancia),
                      const SizedBox(width: 20),
                      _buildDetailIcon(Icons.access_time, tramo.tiempo),
                      const SizedBox(width: 20),
                      _buildDetailIcon(Icons.trending_up, tramo.dificultad),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Este recorrido por el ${tramo.nombre} ofrece una experiencia única rodeada de naturaleza virgen. Ideal para senderismo y observación de aves al amanecer.",
                    style: const TextStyle(color: Colors.black87, height: 1.5),
                  ),

                  const SizedBox(height: 30),

                  //boton grande con el texto "VER EN EL MAPA" y un ícono de mapa a la izquierda, con un fondo verde oscuro y texto blanco, con bordes redondeados
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //aqui se podría usar un provider o bloc para cambiar la pestaña del mapa y mostrar el tramo seleccionado
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cargando tramo en el mapa..."),
                          ),
                        );
                      },
                      icon: const Icon(Icons.map_outlined),
                      label: const Text(
                        "VER EN EL MAPA",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A5F0B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF3A5F0B)),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
