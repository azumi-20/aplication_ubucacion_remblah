import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/tramo_model.dart';
import '../../../map/presentation/screens/map_screen.dart';

class TramoDetailScreen extends StatefulWidget {
  final TramoModel tramo;
  const TramoDetailScreen({super.key, required this.tramo});

  @override
  State<TramoDetailScreen> createState() => _TramoDetailScreenState();
}

class _TramoDetailScreenState extends State<TramoDetailScreen> {
  GoogleMapController? _mapController;
  bool _mapaListo = false;

  @override
  void dispose() {
    if (_mapaListo) _mapController?.dispose();
    super.dispose();
  }

  Set<Polyline> _getPolylines() {
    final t = widget.tramo;
    if (t.latInicio == 0 || t.latFin == 0) return {};
    return {
      // Sombra
      Polyline(
        polylineId: const PolylineId('sombra'),
        points: [LatLng(t.latInicio, t.lngInicio), LatLng(t.latFin, t.lngFin)],
        width: 8,
        color: Colors.black.withOpacity(0.15),
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
      // Línea verde del tramo
      Polyline(
        polylineId: const PolylineId('ruta'),
        points: [LatLng(t.latInicio, t.lngInicio), LatLng(t.latFin, t.lngFin)],
        width: 5,
        color: const Color(0xFF2E7D32),
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  Set<Marker> _getMarkers() {
    final t = widget.tramo;
    if (t.latInicio == 0) return {};
    return {
      Marker(
        markerId: const MarkerId('inicio'),
        position: LatLng(t.latInicio, t.lngInicio),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Inicio: ${t.nombre}'),
      ),
      Marker(
        markerId: const MarkerId('fin'),
        position: LatLng(t.latFin, t.lngFin),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Fin del tramo'),
      ),
    };
  }

  LatLngBounds _bounds() {
    final t = widget.tramo;
    final minLat = t.latInicio < t.latFin ? t.latInicio : t.latFin;
    final maxLat = t.latInicio > t.latFin ? t.latInicio : t.latFin;
    final minLng = t.lngInicio < t.lngFin ? t.lngInicio : t.lngFin;
    final maxLng = t.lngInicio > t.lngFin ? t.lngInicio : t.lngFin;
    return LatLngBounds(
      southwest: LatLng(minLat - 0.05, minLng - 0.05),
      northeast: LatLng(maxLat + 0.05, maxLng + 0.05),
    );
  }

  Color _dificultadColor() {
    switch (widget.tramo.dificultad.toLowerCase()) {
      case 'fácil':    return const Color(0xFF2E7D32);
      case 'moderado': return const Color(0xFFE65100);
      case 'difícil':  return const Color(0xFFC62828);
      default:         return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tramo;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header imagen ──────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF1e2d1e),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(t.imagenUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF1e2d1e),
                        child: const Icon(Icons.landscape, size: 80, color: Colors.white24),
                      )),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20, left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _dificultadColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(t.dificultad,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Text(t.nombre,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // Stats
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _stat(Icons.straighten, t.distancia, 'Distancia'),
                        _divider(),
                        _stat(Icons.access_time, t.tiempo, 'Duración'),
                        _divider(),
                        _stat(Icons.trending_up,
                            t.desnivel.isNotEmpty ? t.desnivel : '--', 'Desnivel'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Descripción
                  const Text('Descripción',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    t.descripcion.isNotEmpty
                        ? t.descripcion
                        : 'Tramo del Camino Remblah — 230 km de recorrido histórico.',
                    style: const TextStyle(color: Colors.black87, height: 1.7, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // Puntos de interés
                  if (t.puntosInteres.isNotEmpty) ...[
                    const Text('Puntos de interés',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    ...t.puntosInteres.map(_puntoItem),
                    const SizedBox(height: 28),
                  ],

                  // Mapa embebido con línea directa (sin Directions API)
                  const Text('Ruta del tramo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (t.latInicio != 0)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 240,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              (t.latInicio + t.latFin) / 2,
                              (t.lngInicio + t.lngFin) / 2,
                            ),
                            zoom: 9,
                          ),
                          polylines: _getPolylines(),
                          markers: _getMarkers(),
                          myLocationButtonEnabled: false,
                          mapToolbarEnabled: false,
                          zoomControlsEnabled: false,
                          onMapCreated: (c) {
                            _mapController = c;
                            _mapaListo = true;
                            Future.delayed(const Duration(milliseconds: 400), () {
                              if (mounted) {
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngBounds(_bounds(), 50));
                              }
                            });
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('Sin coordenadas registradas',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ✅ Botón que navega directo al MapScreen con las coordenadas
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: t.latInicio != 0
                          ? () {
                              // Navega al MapScreen pasando las coordenadas del tramo
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MapScreen(
                                    tramoLat: (t.latInicio + t.latFin) / 2,
                                    tramoLng: (t.lngInicio + t.lngFin) / 2,
                                    tramoNombre: t.nombre,
                                    tramoLatInicio: t.latInicio,
                                    tramoLngInicio: t.lngInicio,
                                    tramoLatFin: t.latFin,
                                    tramoLngFin: t.lngFin,
                                  ),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('VER EN EL MAPA COMPLETO',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String valor, String label) => Column(
    children: [
      Icon(icon, color: const Color(0xFF2E7D32), size: 22),
      const SizedBox(height: 4),
      Text(valor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
    ],
  );

  Widget _divider() => Container(height: 36, width: 1, color: Colors.grey[300]);

  Widget _puntoItem(Map<String, String> punto) {
    IconData icon;
    Color color;
    switch (punto['tipo'] ?? '') {
      case 'vista':    icon = Icons.landscape;  color = const Color(0xFF1565C0); break;
      case 'cafeteria':icon = Icons.coffee;     color = const Color(0xFF6D4C41); break;
      case 'agua':     icon = Icons.water_drop; color = const Color(0xFF0277BD); break;
      case 'camping':  icon = Icons.cabin;      color = const Color(0xFF2E7D32); break;
      default:         icon = Icons.place;      color = Colors.grey;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(punto['nombre'] ?? '',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(punto['tipo'] ?? '',
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
