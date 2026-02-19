// lib/features/comunidad/presentation/screens/detalle_emprendimiento_screen.dart

import 'package:flutter/material.dart';
import 'package:my_secure_app/features/comunidad/models/emprendimiento_model.dart';
import 'package:my_secure_app/features/comunidad/widgets/comunidad_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/*import '../../data/models/emprendimiento_model.dart';
import '../widgets/categoria_badge.dart';
import '../widgets/servicio_item_widget.dart';
import '../widgets/resena_card_widget.dart'; */

class DetalleEmprendimientoScreen extends StatefulWidget {
  final EmprendimientoModel emprendimiento;

  const DetalleEmprendimientoScreen({
    super.key,
    required this.emprendimiento,
  });

  @override
  State<DetalleEmprendimientoScreen> createState() =>
      _DetalleEmprendimientoScreenState();
}

class _DetalleEmprendimientoScreenState
    extends State<DetalleEmprendimientoScreen> {
  bool _esFavorito = false;

  Future<void> _llamar() async {
    final uri = Uri.parse('tel:${widget.emprendimiento.telefono}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.emprendimiento;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Hero Image ──
                  SliverToBoxAdapter(
                    child: _HeroImage(
                      emprendimiento: e,
                      esFavorito: _esFavorito,
                      onToggleFav: () =>
                          setState(() => _esFavorito = !_esFavorito),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ── Titulo + badge ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                e.nombre,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            CategoriaBadge(categoria: e.categoria),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // ── Ubicación ──
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Color(0xFF757575),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              e.ubicacion,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // ── Rating ──
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Color(0xFF4CAF50),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              e.calificacion.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${e.totalResenas} reseñas)',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ── Descripción ──
                        const Text(
                          'Sobre el Emprendimiento',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          e.descripcionLarga,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Info de contacto ──
                        _ContactoBox(emprendimiento: e),
                        const SizedBox(height: 24),

                        // ── Servicios ──
                        const Text(
                          'Servicios Ofrecidos',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...e.servicios.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ServicioItemWidget(servicio: s),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Reseñas ──
                        const Text(
                          'Reseñas Recientes',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...e.resenas.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ResenaCardWidget(resena: r),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Botones de acción ──
                        ElevatedButton.icon(
                          onPressed: _llamar,
                          icon: const Icon(Icons.phone),
                          label: const Text('Llamar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.directions),
                          label: const Text('Cómo Llegar'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1A1A1A),
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(color: Color(0xFFE8E8E8)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero image widget ─────────────────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  final EmprendimientoModel emprendimiento;
  final bool esFavorito;
  final VoidCallback onToggleFav;

  const _HeroImage({
    required this.emprendimiento,
    required this.esFavorito,
    required this.onToggleFav,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            emprendimiento.imagenUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFFE8E8E8)),
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [Color(0x80000000), Colors.transparent],
              ),
            ),
          ),
          // Back + fav buttons
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleBtn(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 20),
                ),
                _CircleBtn(
                  onTap: onToggleFav,
                  child: Icon(
                    esFavorito ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: esFavorito ? Colors.red : null,
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

class _CircleBtn extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _CircleBtn({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ── Caja de contacto ─────────────────────────────────────────────────────────
class _ContactoBox extends StatelessWidget {
  final EmprendimientoModel emprendimiento;
  const _ContactoBox({required this.emprendimiento});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Contacto',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.person, text: emprendimiento.contactoNombre),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.phone, text: emprendimiento.telefono),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.schedule, text: emprendimiento.horario),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4CAF50)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
          ),
        ),
      ],
    );
  }
}
