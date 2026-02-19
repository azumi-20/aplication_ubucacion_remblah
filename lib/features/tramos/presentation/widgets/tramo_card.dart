import 'package:flutter/material.dart';
import '../../models/tramo_model.dart';

class TramoCard extends StatelessWidget {
  final TramoModel tramo;
  final VoidCallback onTap;

  const TramoCard({super.key, required this.tramo, required this.onTap});

  Color _dificultadColor() {
    switch (tramo.dificultad.toLowerCase()) {
      case 'fácil':    return const Color(0xFF2E7D32);
      case 'moderado': return const Color(0xFFE65100);
      case 'difícil':  return const Color(0xFFC62828);
      default:         return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            Image.network(
              tramo.imagenUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1e2d1e),
                child: const Icon(Icons.landscape, size: 60, color: Colors.white24),
              ),
            ),

            // Gradiente oscuro
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.75),
                  ],
                ),
              ),
            ),

            // Badge dificultad arriba derecha
            Positioned(
              top: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _dificultadColor(),
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

            // Nombre + distancia abajo
            Positioned(
              bottom: 14, left: 16, right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tramo.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.straighten, color: Colors.white70, size: 13),
                      const SizedBox(width: 4),
                      Text(tramo.distancia,
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, color: Colors.white70, size: 13),
                      const SizedBox(width: 4),
                      Text(tramo.tiempo,
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            // Flecha ver más
            const Positioned(
              top: 12, left: 12,
              child: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}

