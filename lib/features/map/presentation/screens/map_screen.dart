import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../state/map_state.dart';
import '../widgets/map_layer_panel.dart';
import '../widgets/current_location_card.dart';
import 'hito_detail_screen.dart';
import '../../data/model/hito.dart';
import '../../data/api/google_places_api.dart';
import '../../data/api/wikipedia_api.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapState state = MapState();

  bool showPanel = false;
  bool showCard = false;
  bool cargando = false;

  String cardTitle = "";
  String buttonText = "";

  List<Hito> hitos = [];
  LatLng? _nuevoHitoLatLng;

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(14.6349, -90.5069),
    zoom: 13,
  );

  final String _mapStyle = '''
  [
    {
      "featureType": "poi",
      "stylers": [{ "visibility": "off" }]
    },
    {
      "featureType": "transit",
      "stylers": [{ "visibility": "off" }]
    }
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _cargarHitos();
  }

  Future<void> _cargarHitos() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('lugares').get();
    final List<Hito> lista = snapshot.docs.map((doc) {
      return Hito.fromMap(doc.id, doc.data());
    }).toList();

    setState(() {
      hitos = lista;
    });
  }

  void _onFilterChange(MapState newState) {
    setState(() {
      state = newState;
      showCard = true;

      if (state.showTramos) {
        cardTitle = "Tramo seleccionado";
        buttonText = "Ver tramo";
      } else if (state.showHitos) {
        cardTitle = "Hito seleccionado";
        buttonText = "Ver hito";
      } else if (state.showEventos) {
        cardTitle = "Evento seleccionado";
        buttonText = "Ver evento";
      } else if (state.showEmprendimientos) {
        cardTitle = "Emprendimiento seleccionado";
        buttonText = "Ver emprendimiento";
      } else {
        cardTitle = "Punto seleccionado";
        buttonText = "Ver detalle";
      }
    });
  }

  void _onMapTap(LatLng tappedPoint) async {
    setState(() {
      _nuevoHitoLatLng = tappedPoint;
      cargando = true;
      showCard = true;
      cardTitle = "Buscando lugar…";
      buttonText = "Ver hito";
    });

    try {
      final conectividad = await Connectivity().checkConnectivity();
      final tieneInternet = conectividad != ConnectivityResult.none;

      if (tieneInternet) {
        // ── CON INTERNET ──────────────────────────────────────
        final placeBasico = await GooglePlacesApi.getPlaceFromLatLng(
          tappedPoint.latitude,
          tappedPoint.longitude,
        );

        if (placeBasico == null) {
          setState(() { cargando = false; showCard = false; });
          return;
        }

        final placeId = placeBasico['place_id'] as String;

        final snapshot = await FirebaseFirestore.instance
            .collection('lugares')
            .where('placeId', isEqualTo: placeId)
            .limit(1)
            .get();

        Hito hitoSeleccionado;

        if (snapshot.docs.isNotEmpty) {
          // Ya está en Firebase
          hitoSeleccionado = Hito.fromMap(
            snapshot.docs.first.id,
            snapshot.docs.first.data(),
          );
        } else {
          // No está — traer de Places + Wikipedia
          final detalle = await GooglePlacesApi.getPlaceDetails(placeId);

          if (detalle == null) {
            setState(() { cargando = false; showCard = false; });
            return;
          }

          final wikiResumen =
              await WikipediaApi.getResumen(detalle['name'] ?? '');
          final hitoNuevo = Hito.fromPlaces(
            detalle,
            wikiResumen: wikiResumen ?? '',
          );

          final docRef = await FirebaseFirestore.instance
              .collection('lugares')
              .add(hitoNuevo.toMap());

          hitoSeleccionado = Hito.fromMap(docRef.id, hitoNuevo.toMap());
          setState(() { hitos.add(hitoSeleccionado); });
        }

        setState(() {
          cargando = false;
          cardTitle = hitoSeleccionado.nombre;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HitoDetailScreen(hito: hitoSeleccionado),
          ),
        );

      } else {
        // ── SIN INTERNET ──────────────────────────────────────
        if (hitos.isEmpty) {
          setState(() { cargando = false; showCard = false; });
          _mostrarSnack('Sin conexión y sin datos guardados');
          return;
        }

        Hito? hitoMasCercano;
        double menorDistancia = double.infinity;

        for (final hito in hitos) {
          final distancia = _calcularDistancia(
            tappedPoint.latitude, tappedPoint.longitude,
            hito.lat, hito.lng,
          );
          if (distancia < menorDistancia) {
            menorDistancia = distancia;
            hitoMasCercano = hito;
          }
        }

        if (hitoMasCercano == null || menorDistancia > 100) {
          setState(() { cargando = false; showCard = false; });
          _mostrarSnack('Sin conexión — toca un hito guardado');
          return;
        }

        setState(() {
          cargando = false;
          cardTitle = hitoMasCercano!.nombre;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HitoDetailScreen(hito: hitoMasCercano!),
          ),
        );
      }
    } catch (e) {
      debugPrint('ERROR _onMapTap: $e');
      setState(() { cargando = false; showCard = false; });
    }
  }

  double _calcularDistancia(
      double lat1, double lng1, double lat2, double lng2) {
    final dLat = (lat2 - lat1).abs() * 111000;
    final dLng = (lng2 - lng1).abs() * 111000;
    return (dLat + dLng) / 2;
  }

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Set<Marker> _obtenerMarcadores() {
    return hitos.map((hito) {
      return Marker(
        markerId: MarkerId(hito.id),
        position: LatLng(hito.lat, hito.lng),
        infoWindow: InfoWindow(
          title: hito.nombre,
          snippet: hito.direccion,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          setState(() {
            cardTitle = hito.nombre;
            buttonText = "Ver hito";
            showCard = true;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HitoDetailScreen(hito: hito),
            ),
          );
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Eventos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            markers: _obtenerMarcadores(),
            onMapCreated: (controller) => controller.setMapStyle(_mapStyle),
            onTap: _onMapTap,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circle(Icons.arrow_back,
                      onTap: () => Navigator.pop(context)),
                  Row(
                    children: [
                      _circle(Icons.my_location, onTap: () {
                        setState(() {
                          showCard = true;
                          cardTitle = "Tu ubicación actual";
                          buttonText = "Ver ubicación";
                        });
                      }),
                      const SizedBox(width: 8),
                      _circle(Icons.layers, onTap: () {
                        setState(() => showPanel = !showPanel);
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),

          if (showPanel)
            Positioned(
              top: 80,
              right: 16,
              child: MapLayerPanel(
                state: state,
                onChanged: _onFilterChange,
              ),
            ),

          if (cargando)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.green),
                        SizedBox(height: 12),
                        Text("Buscando lugar…"),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          if (showCard && !cargando)
            Positioned(
              bottom: 90,
              left: 16,
              right: 16,
              child: CurrentLocationCard(
                title: cardTitle,
                buttonText: buttonText,
                onClose: () => setState(() => showCard = false),
                onPressed: () {
                  if (_nuevoHitoLatLng != null) {
                    _onMapTap(_nuevoHitoLatLng!);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _circle(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}