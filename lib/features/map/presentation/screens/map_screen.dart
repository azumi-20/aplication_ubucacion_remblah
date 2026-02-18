import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../state/map_state.dart';
import 'hito_detail_screen.dart';
import '../../data/model/hito.dart';
import '../../data/api/google_places_api.dart';
import '../../data/api/wikipedia_api.dart';

// ─────────────────────────────────────────────────────────────
// ⚙️  CONFIG
// ─────────────────────────────────────────────────────────────
const String _kGoogleApiKey = 'TU_API_KEY_AQUI';

String _buildFotoUrl(String ref) {
  if (ref.isEmpty) return '';
  if (ref.startsWith('http')) return ref;
  return 'https://maps.googleapis.com/maps/api/place/photo'
      '?maxwidth=600&photo_reference=$ref&key=$_kGoogleApiKey';
}

// ─────────────────────────────────────────────────────────────
// 🗺️  BOUNDING BOX
// ─────────────────────────────────────────────────────────────
final LatLngBounds _trayectoBounds = LatLngBounds(
  southwest: const LatLng(15.30, -87.10),
  northeast: const LatLng(16.00, -85.50),
);

bool _dentroDelTrayecto(double lat, double lng) =>
    lat >= _trayectoBounds.southwest.latitude &&
    lat <= _trayectoBounds.northeast.latitude &&
    lng >= _trayectoBounds.southwest.longitude &&
    lng <= _trayectoBounds.northeast.longitude;

// ─────────────────────────────────────────────────────────────
// 🏷️  TIPOS — colores discretos
// ─────────────────────────────────────────────────────────────
enum TipoHito { hito, tramo, emprendimiento, comunidad, estacion, lugar }

TipoHito _detectarTipo(String tipo) {
  switch (tipo.toLowerCase().trim()) {
    case 'tramo':          return TipoHito.tramo;
    case 'emprendimiento': return TipoHito.emprendimiento;
    case 'comunidad':      return TipoHito.comunidad;
    case 'estacion':
    case 'estación':       return TipoHito.estacion;
    case 'lugar':          return TipoHito.lugar;
    default:               return TipoHito.hito;
  }
}

Color _color(TipoHito t) {
  switch (t) {
    case TipoHito.tramo:          return const Color(0xFF2E8B57);
    case TipoHito.emprendimiento: return const Color(0xFF9B59B6);
    case TipoHito.comunidad:      return const Color(0xFF4A90D9);
    case TipoHito.estacion:       return const Color(0xFFE05C5C);
    case TipoHito.lugar:          return const Color(0xFF90A4AE);
    default:                      return const Color(0xFFD4A017);
  }
}

// ─────────────────────────────────────────────────────────────
// 🔵  PUNTO PEQUEÑO — marcador minimalista
//     Círculo sólido de color con borde blanco sutil
// ─────────────────────────────────────────────────────────────
Future<BitmapDescriptor> _puntoPequeno(TipoHito tipo, {int size = 28}) async {
  final rec = ui.PictureRecorder();
  final canvas = Canvas(rec);
  final r = size / 2.0;
  final col = _color(tipo);

  // Sombra sutil
  canvas.drawCircle(
    Offset(r, r + 2),
    r - 3,
    Paint()
      ..color = Colors.black.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
  );

  // Círculo de color
  canvas.drawCircle(Offset(r, r), r - 3, Paint()..color = col);

  // Borde blanco
  canvas.drawCircle(
    Offset(r, r),
    r - 3,
    Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5,
  );

  final img = await rec.endRecording().toImage(size, size);
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

// ─────────────────────────────────────────────────────────────
// 🗺️  MapScreen
// ─────────────────────────────────────────────────────────────
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<Hito> _hitos = [];
  Set<Marker> _marcadores = {};
  bool _cargando = false;

  static const _camara = CameraPosition(
    target: LatLng(15.60, -86.80),
    zoom: 8,
    tilt: 40,
  );

  // ✅ weight como int — sin crash en web
  final String _mapStyle = '''[
    {"elementType":"geometry","stylers":[{"color":"#1a1f2e"}]},
    {"elementType":"labels.text.fill","stylers":[{"color":"#9ab0b8"}]},
    {"elementType":"labels.text.stroke","stylers":[{"color":"#1a1f2e"}]},
    {"featureType":"road","elementType":"geometry","stylers":[{"color":"#2c3e5e"}]},
    {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3a5080"}]},
    {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#7a99a8"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0d1520"}]},
    {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d6880"}]},
    {"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#1e2d1e"}]},
    {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#1e3320"}]},
    {"featureType":"poi","stylers":[{"visibility":"off"}]},
    {"featureType":"transit","stylers":[{"visibility":"off"}]},
    {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#3a5080"},{"weight":1}]},
    {"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#9ab0b8"}]}
  ]''';

  @override
  void initState() {
    super.initState();
    _cargarHitos();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _cargarHitos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('lugares')
        .get();

    final lista = snapshot.docs
        .map((d) => Hito.fromMap(d.id, d.data()))
        .where((h) => _dentroDelTrayecto(h.lat, h.lng))
        .toList();

    setState(() => _hitos = lista);
    await _construirMarcadores(lista);
  }

  Future<void> _construirMarcadores(List<Hito> lista) async {
    final Set<Marker> nuevos = {};
    for (final hito in lista) {
      final tipo = _detectarTipo(hito.tipo);
      final icono = await _puntoPequeno(tipo);

      nuevos.add(Marker(
        markerId: MarkerId(hito.id),
        position: LatLng(hito.lat, hito.lng),
        icon: icono,
        anchor: const Offset(0.5, 0.5),
        // Toca el punto → abre detalle directamente
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HitoDetailScreen(hito: hito)),
        ),
      ));
    }
    if (mounted) setState(() => _marcadores = nuevos);
  }

  void _centrar() {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(const CameraPosition(
        target: LatLng(15.60, -86.80),
        zoom: 9,
        tilt: 40,
      )),
    );
  }

  // Al tocar el mapa → busca en Google Places y guarda en Firebase
  void _onMapTap(LatLng point) async {
    if (!_dentroDelTrayecto(point.latitude, point.longitude)) return;

    setState(() => _cargando = true);

    final placeBasico = await GooglePlacesApi.getPlaceFromLatLng(
      point.latitude, point.longitude,
    );
    if (placeBasico == null) {
      setState(() => _cargando = false);
      return;
    }

    final placeId = placeBasico['place_id'] as String;
    final snap = await FirebaseFirestore.instance
        .collection('lugares')
        .where('placeId', isEqualTo: placeId)
        .limit(1)
        .get();

    Hito hitoSel;
    if (snap.docs.isNotEmpty) {
      hitoSel = Hito.fromMap(snap.docs.first.id, snap.docs.first.data());
    } else {
      final detalle = await GooglePlacesApi.getPlaceDetails(placeId);
      final wiki = await WikipediaApi.getResumen(detalle?['name'] ?? '');
      final nuevo = Hito.fromPlaces(detalle!, wikiResumen: wiki ?? '');
      final ref = await FirebaseFirestore.instance
          .collection('lugares')
          .add(nuevo.toMap());
      hitoSel = Hito.fromMap(ref.id, nuevo.toMap());

      // Agrega el punto al mapa
      final tipo = _detectarTipo(hitoSel.tipo);
      final icono = await _puntoPequeno(tipo);
      setState(() {
        _hitos.add(hitoSel);
        _marcadores = {
          ..._marcadores,
          Marker(
            markerId: MarkerId(hitoSel.id),
            position: LatLng(hitoSel.lat, hitoSel.lng),
            icon: icono,
            anchor: const Offset(0.5, 0.5),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => HitoDetailScreen(hito: hitoSel)),
            ),
          ),
        };
      });
    }

    setState(() => _cargando = false);

    // Abre el detalle directamente
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HitoDetailScreen(hito: hitoSel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _camara,
            markers: _marcadores,
            cameraTargetBounds: CameraTargetBounds(_trayectoBounds),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (c) {
              _controller = c;
              c.setMapStyle(_mapStyle);
              _centrar();
            },
            onTap: _onMapTap,
          ),

          // Botón centrar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: _centrar,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2233),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.45),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.my_location_rounded,
                    color: Colors.white70, size: 20),
              ),
            ),
          ),

          // Loading
          if (_cargando)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2233),
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                          color: Color(0xFFD4A017), strokeWidth: 2),
                      SizedBox(height: 14),
                      Text('Buscando lugar...',
                          style: TextStyle(
                              color: Colors.white60, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
