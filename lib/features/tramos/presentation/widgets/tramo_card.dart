import 'package:flutter/material.dart';
import '../../models/tramo_model.dart';

class TramoCard extends StatelessWidget {
  final TramoModel tramo;
  final VoidCallback onTap;

  const TramoCard({
    super.key,
    required this.tramo,
    required this.onTap,
  });

  //función que asigna un color a cada dificultad para que el usuario pueda identificarla rápidamente.
  Color _getDificultadColor() {
    switch (tramo.dificultad.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'moderado':
        return Colors.orange;
      case 'difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        clipBehavior: Clip
            .antiAlias, //permite que la imagen se recorte con bordes redondeados
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagen del tramo con etiqueta de dificultad
            Stack(
              children: [
                Image.network(
                  tramo.imagenUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDificultadColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tramo.dificultad,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // info del tramo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tramo.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoIcon(Icons.straighten, tramo.distancia),
                      _buildInfoIcon(Icons.access_time, tramo.tiempo),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // este widget se utiliza para mostrar un icono junto a un texto, como la distancia o el tiempo del tramo.
  Widget _buildInfoIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF3A5F0B)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}
