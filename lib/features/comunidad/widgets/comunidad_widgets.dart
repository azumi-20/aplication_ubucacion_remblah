// ============================================================
// lib/features/comunidad/presentation/widgets/categoria_chip.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:my_secure_app/features/comunidad/models/emprendimiento_model.dart';

class CategoriaChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoriaChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF4CAF50) : const Color(0xFFE8E8E8),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF757575),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// lib/features/comunidad/presentation/widgets/categoria_badge.dart
// ============================================================

class CategoriaBadge extends StatelessWidget {
  final String categoria;
  const CategoriaBadge({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    final data = _badgeData(categoria);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: data['bg'] as Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        data['label'] as String,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: data['color'] as Color,
        ),
      ),
    );
  }

  Map<String, dynamic> _badgeData(String categoria) {
    switch (categoria) {
      case 'gastronomia':
        return {
          'label': 'Gastronomía',
          'bg': const Color(0xFFE8F5E9),
          'color': const Color(0xFF388E3C),
        };
      case 'artesania':
        return {
          'label': 'Artesanía',
          'bg': const Color(0xFFF3E5F5),
          'color': const Color(0xFF7B1FA2),
        };
      case 'hospedaje':
        return {
          'label': 'Hospedaje',
          'bg': const Color(0xFFE3F2FD),
          'color': const Color(0xFF1565C0),
        };
      default:
        return {
          'label': categoria,
          'bg': const Color(0xFFE8E8E8),
          'color': const Color(0xFF757575),
        };
    }
  }
}

// ============================================================
// lib/features/comunidad/presentation/widgets/emprendimiento_card.dart
// ============================================================

class EmprendimientoCard extends StatelessWidget {
  final EmprendimientoModel emprendimiento;
  final VoidCallback onTap;

  const EmprendimientoCard({
    super.key,
    required this.emprendimiento,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Row(
            children: [
              // Imagen
              SizedBox(
                width: 110,
                height: 110,
                child: Image.network(
                  emprendimiento.imagenUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFE8E8E8)),
                ),
              ),
              // Contenido
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              emprendimiento.nombre,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CategoriaBadge(categoria: emprendimiento.categoria),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        emprendimiento.descripcionCorta,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF757575),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xFF757575),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            emprendimiento.tramo,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// lib/features/comunidad/presentation/widgets/servicio_item_widget.dart
// ============================================================

class ServicioItemWidget extends StatelessWidget {
  final ServicioModel servicio;
  const ServicioItemWidget({super.key, required this.servicio});

  static final _iconMap = <String, IconData>{
    'local_cafe': Icons.local_cafe,
    'agriculture': Icons.agriculture,
    'restaurant': Icons.restaurant,
    'checkroom': Icons.checkroom,
    'palette': Icons.palette,
    'shopping_bag': Icons.shopping_bag,
    'bed': Icons.bed,
    'free_breakfast': Icons.free_breakfast,
    'luggage': Icons.luggage,
    'soup_kitchen': Icons.soup_kitchen,
    'eco': Icons.eco,
    'takeout_dining': Icons.takeout_dining,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Icon(
            _iconMap[servicio.icono] ?? Icons.info_outline,
            size: 24,
            color: const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  servicio.titulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  servicio.descripcion,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// lib/features/comunidad/presentation/widgets/resena_card_widget.dart
// ============================================================

class ResenaCardWidget extends StatelessWidget {
  final ResenaModel resena;
  const ResenaCardWidget({super.key, required this.resena});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resena.nombre,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: List.generate(
                  resena.estrellas,
                  (_) => const Icon(
                    Icons.star,
                    size: 14,
                    color: Color(0xFFFFB300),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            resena.texto,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF757575),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            resena.fecha,
            style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA)),
          ),
        ],
      ),
    );
  }
}
