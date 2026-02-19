import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../state/map_state.dart';
import 'hito_detail_screen.dart';
import '../../data/model/hito.dart';
import '../../data/api/google_places_api.dart';
import '../../data/api/wikipedia_api.dart';

const String _kGoogleApiKey = 'TU_API_KEY_AQUI';

String _buildFotoUrl(String ref) {
  if (ref.isEmpty) return '';
  if (ref.startsWith('http')) return ref;
  return 'https://maps.googleapis.com/maps/api/place/photo'
      '?maxwidth=600&photo_reference=$ref&key=$_kGoogleApiKey';
}

final LatLngBounds _trayectoBounds = LatLngBounds(
  southwest: const LatLng(15.30, -87.10),
  northeast: const LatLng(16.00, -85.50),
);

bool _dentroDelTrayecto(double lat, double lng) =>
    lat >= _trayectoBounds.southwest.latitude &&
    lat <= _trayectoBounds.northeast.latitude &&
    lng >= _trayectoBounds.southwest.longitude &&
    lng <= _trayectoBounds.northeast.longitude;

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
    default:                      return const Color(0xFFD4A017); // dorado
  }
}

// Punto pequeño para hitos
Future<BitmapDescriptor> _puntoPequeno(TipoHito tipo, {int size = 28}) async {
  final rec = ui.PictureRecorder();
  final canvas = Canvas(rec);
  final r = size / 2.0;
  final col = _color(tipo);
  canvas.drawCircle(Offset(r, r + 2), r - 3,
      Paint()
        ..color = Colors.black.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
  canvas.drawCircle(Offset(r, r), r - 3, Paint()..color = col);
  canvas.drawCircle(Offset(r, r), r - 3,
      Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5);
  final img = await rec.endRecording().toImage(size, size);
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

// ─────────────────────────────────────────────────────────────
// MapScreen — parámetros opcionales para mostrar un tramo
// ─────────────────────────────────────────────────────────────
class MapScreen extends StatefulWidget {
  // Cuando viene desde TramoDetailScreen
  final double? tramoLat;
  final double? tramoLng;
  final String? tramoNombre;
  final double? tramoLatInicio;
  final double? tramoLngInicio;
  final double? tramoLatFin;
  final double? tramoLngFin;

  const MapScreen({
    super.key,
    this.tramoLat,
    this.tramoLng,
    this.tramoNombre,
    this.tramoLatInicio,
    this.tramoLngInicio,
    this.tramoLatFin,
    this.tramoLngFin,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  List<Hito> _hitos = [];
  Set<Marker> _marcadores = {};
  Set<Polyline> _polylines = {};
  bool _cargando = false;
  bool _buscandoUbicacion = false;

  CameraPosition get _camaraInicial {
    if (widget.tramoLat != null && widget.tramoLng != null) {
      return CameraPosition(
        target: LatLng(widget.tramoLat!, widget.tramoLng!),
        zoom: 10,
        tilt: 40,
      );
    }
    return const CameraPosition(
      target: LatLng(15.60, -86.80),
      zoom: 8,
      tilt: 40,
    );
  }

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
    if (widget.tramoLatInicio != null) _prepararTramo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ── Banderas verdes del tramo ──────────────────────────────
  void _prepararTramo() {
    final latIni = widget.tramoLatInicio!;
    final lngIni = widget.tramoLngInicio!;
    final latFin = widget.tramoLatFin!;
    final lngFin = widget.tramoLngFin!;
    final nombre = widget.tramoNombre ?? 'Tramo';

    setState(() {
      // Línea verde entre inicio y fin
      _polylines = {
        Polyline(
          polylineId: const PolylineId('tramo_sombra'),
          points: [LatLng(latIni, lngIni), LatLng(latFin, lngFin)],
          width: 8,
          color: Colors.black.withOpacity(0.2),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
        Polyline(
          polylineId: const PolylineId('tramo_linea'),
          points: [LatLng(latIni, lngIni), LatLng(latFin, lngFin)],
          width: 5,
          color: const Color(0xFF2E7D32),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      };

      // Bandera verde inicio + roja fin
      _marcadores = {
        Marker(
          markerId: const MarkerId('tramo_inicio'),
          position: LatLng(latIni, lngIni),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Inicio: $nombre'),
        ),
        Marker(
          markerId: const MarkerId('tramo_fin'),
          position: LatLng(latFin, lngFin),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Fin del tramo'),
        ),
      };
    });
  }

  // ── Hitos dorados de Firebase ──────────────────────────────
  Future<void> _cargarHitos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('lugares').get();
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
        markerId: MarkerId('hito_${hito.id}'),
        position: LatLng(hito.lat, hito.lng),
        icon: icono,
        anchor: const Offset(0.5, 0.5),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HitoDetailScreen(hito: hito))),
      ));
    }
    // Combina con los marcadores del tramo si existen
    if (mounted) setState(() => _marcadores = {..._marcadores, ...nuevos});
  }

  void _centrar() {
    if (widget.tramoLat != null) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.tramoLat!, widget.tramoLng!),
          zoom: 10, tilt: 40,
        ),
      ));
    } else {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
            target: LatLng(15.60, -86.80), zoom: 9, tilt: 40),
      ));
    }
  }

  Future<void> _irAMiUbicacion() async {
    setState(() => _buscandoUbicacion = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _mostrarMensaje(icono: Icons.location_off,
            color: const Color(0xFFE05C5C),
            titulo: 'GPS desactivado',
            mensaje: 'Activa el GPS de tu dispositivo.');
        return;
      }
      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.denied) {
          _mostrarMensaje(icono: Icons.location_disabled,
              color: const Color(0xFFE05C5C),
              titulo: 'Permiso denegado',
              mensaje: 'Necesitamos acceso a tu ubicación.');
          return;
        }
      }
      if (permiso == LocationPermission.deniedForever) {
        _mostrarMensaje(icono: Icons.location_disabled,
            color: const Color(0xFFE05C5C),
            titulo: 'Permiso bloqueado',
            mensaje: 'Ve a Configuración → Permisos y activa la ubicación.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!_dentroDelTrayecto(pos.latitude, pos.longitude)) {
        _mostrarMensaje(
          icono: Icons.wrong_location,
          color: const Color(0xFFE05C5C),
          titulo: '¡Fuera de ruta!',
          mensaje: 'Tu ubicación actual está fuera del Camino Remblah.\n'
              'El trayecto va de La Ceiba a Olanchito (230 km).',
          botonExtra: TextButton(
            onPressed: () { Navigator.pop(context); _centrar(); },
            child: const Text('Ver el trayecto',
                style: TextStyle(color: Color(0xFFD4A017))),
          ),
        );
        return;
      }
      _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(pos.latitude, pos.longitude), zoom: 14, tilt: 45),
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          backgroundColor: const Color(0xFF2E8B57),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          content: const Row(children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('¡Estás en el Camino Remblah!',
                style: TextStyle(color: Colors.white)),
          ]),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (_) {
      _mostrarMensaje(icono: Icons.error_outline, color: Colors.grey,
          titulo: 'Error',
          mensaje: 'No se pudo obtener tu ubicación. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _buscandoUbicacion = false);
    }
  }

  void _mostrarMensaje({
    required IconData icono, required Color color,
    required String titulo, required String mensaje, Widget? botonExtra,
  }) {
    if (!mounted) return;
    setState(() => _buscandoUbicacion = false);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1C2233),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 60, height: 60,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(icono, color: color, size: 30)),
            const SizedBox(height: 16),
            Text(titulo, style: const TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(mensaje, textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.65),
                    fontSize: 13, height: 1.5)),
            const SizedBox(height: 20),
            if (botonExtra != null) botonExtra,
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar',
                  style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ),
          ]),
        ),
      ),
    );
  }

  void _onMapTap(LatLng point) async {
    if (!_dentroDelTrayecto(point.latitude, point.longitude)) return;
    setState(() => _cargando = true);
    final placeBasico = await GooglePlacesApi.getPlaceFromLatLng(
        point.latitude, point.longitude);
    if (placeBasico == null) { setState(() => _cargando = false); return; }
    final placeId = placeBasico['place_id'] as String;
    final snap = await FirebaseFirestore.instance
        .collection('lugares')
        .where('placeId', isEqualTo: placeId).limit(1).get();
    Hito hitoSel;
    if (snap.docs.isNotEmpty) {
      hitoSel = Hito.fromMap(snap.docs.first.id, snap.docs.first.data());
    } else {
      final detalle = await GooglePlacesApi.getPlaceDetails(placeId);
      final wiki = await WikipediaApi.getResumen(detalle?['name'] ?? '');
      final nuevo = Hito.fromPlaces(detalle!, wikiResumen: wiki ?? '');
      final ref = await FirebaseFirestore.instance
          .collection('lugares').add(nuevo.toMap());
      hitoSel = Hito.fromMap(ref.id, nuevo.toMap());
      final tipo = _detectarTipo(hitoSel.tipo);
      final icono = await _puntoPequeno(tipo);
      setState(() {
        _hitos.add(hitoSel);
        _marcadores = {
          ..._marcadores,
          Marker(
            markerId: MarkerId('hito_${hitoSel.id}'),
            position: LatLng(hitoSel.lat, hitoSel.lng),
            icon: icono, anchor: const Offset(0.5, 0.5),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => HitoDetailScreen(hito: hitoSel))),
          ),
        };
      });
    }
    setState(() => _cargando = false);
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => HitoDetailScreen(hito: hitoSel)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _camaraInicial,
            markers: _marcadores,
            polylines: _polylines,
            cameraTargetBounds: CameraTargetBounds(_trayectoBounds),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (c) {
              _controller = c;
              c.setMapStyle(_mapStyle);
              // Si viene con tramo, ajusta cámara para ver inicio y fin
              if (widget.tramoLatInicio != null) {
                Future.delayed(const Duration(milliseconds: 400), () {
                  if (!mounted) return;
                  final minLat = widget.tramoLatInicio! < widget.tramoLatFin!
                      ? widget.tramoLatInicio! : widget.tramoLatFin!;
                  final maxLat = widget.tramoLatInicio! > widget.tramoLatFin!
                      ? widget.tramoLatInicio! : widget.tramoLatFin!;
                  final minLng = widget.tramoLngInicio! < widget.tramoLngFin!
                      ? widget.tramoLngInicio! : widget.tramoLngFin!;
                  final maxLng = widget.tramoLngInicio! > widget.tramoLngFin!
                      ? widget.tramoLngInicio! : widget.tramoLngFin!;
                  c.animateCamera(CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      southwest: LatLng(minLat - 0.05, minLng - 0.05),
                      northeast: LatLng(maxLat + 0.05, maxLng + 0.05),
                    ),
                    60,
                  ));
                });
              } else {
                _centrar();
              }
            },
            onTap: _onMapTap,
          ),

          // Botón volver al detalle del tramo
          if (widget.tramoNombre != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2233),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.15)),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.45),
                        blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.arrow_back,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: Text(widget.tramoNombre!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                ),
              ),
            ),

          // Botón mi ubicación
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: _buscandoUbicacion ? null : _irAMiUbicacion,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2233),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.15)),
                  boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.45),
                      blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: _buscandoUbicacion
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            color: Colors.white70, strokeWidth: 2))
                    : const Icon(Icons.my_location_rounded,
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
                    border: Border.all(
                        color: Colors.white.withOpacity(0.08)),
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
                      ]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
