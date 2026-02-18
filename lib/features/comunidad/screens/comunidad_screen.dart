// lib/features/comunidad/presentation/screens/comunidad_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_secure_app/features/comunidad/widgets/comunidad_widgets.dart';
import 'package:my_secure_app/features/comunidad/notifiers/comunidad_notifier.dart';
import 'package:my_secure_app/features/comunidad/models/emprendimiento_model.dart';
import 'package:my_secure_app/features/comunidad/screens/detalle_emprendimiento_screen.dart';
//import '../../data/models/emprendimiento_model.dart';
//import '../notifiers/comunidad_notifier.dart';
//import '../widgets/emprendimiento_card.dart';
//import '../widgets/categoria_chip.dart';
//import 'detalle_emprendimiento_screen.dart';

class ComunidadScreen extends ConsumerWidget {
  const ComunidadScreen({super.key});

  static const List<Map<String, String>> _categorias = [
    {'id': 'all', 'label': 'Todos'},
    {'id': 'gastronomia', 'label': 'Gastronomía'},
    {'id': 'artesania', 'label': 'Artesanías'},
    {'id': 'hospedaje', 'label': 'Hospedaje'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(comunidadProvider);
    final notifier = ref.read(comunidadProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Offline indicator ──
            _OfflineIndicator(),

            // ── Top App Bar ──
            _TopBar(),

            // ── Scrollable body ──
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Encabezado de sección
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Emprendimientos Locales',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Conoce y apoya a las comunidades del camino',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Filtros horizontales
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                        itemCount: _categorias.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final cat = _categorias[index];
                          return CategoriaChip(
                            label: cat['label']!,
                            isActive: state.categoriaActiva == cat['id'],
                            onTap: () =>
                                notifier.filtrarPorCategoria(cat['id']!),
                          );
                        },
                      ),
                    ),
                  ),

                  // Lista de emprendimientos
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final e = state.filtrados[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: EmprendimientoCard(
                              emprendimiento: e,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalleEmprendimientoScreen(
                                    emprendimiento: e,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: state.filtrados.length,
                      ),
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

// ── Sub-widgets privados ──────────────────────────────────────────────────────

class _OfflineIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1FBF1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.cloud_done, size: 16, color: Color(0xFF388E3C)),
          SizedBox(width: 8),
          Text(
            'Contenido disponible sin conexión',
            style: TextStyle(fontSize: 12, color: Color(0xFF388E3C)),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Expanded(
            child: Text(
              'Comunidades',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 48), // balance
        ],
      ),
    );
  }
}
