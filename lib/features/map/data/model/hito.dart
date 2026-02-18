class Hito {
  final String id;
  final String placeId;
  final String nombre;
  final String descripcion;
  final String descripcionWiki;
  final String descripcionWiki; 
  final String direccion;
  final String tipos;
  final String estado;
  final double lat;
  final double lng;
  final List<String> fotos;
  final String urlMaps;
  final bool accesible;
  final String iconUrl;
  final String tipo;

  Hito({
    required this.id,
    required this.placeId,
    required this.nombre,
    required this.descripcion,
    required this.descripcionWiki,
    required this.direccion,
    required this.tipos,
    required this.estado,
    required this.lat,
    required this.lng,
    required this.fotos,
    required this.urlMaps,
    required this.accesible,
    required this.iconUrl,
    required this.tipo,
  });

  factory Hito.fromMap(String id, Map<String, dynamic> data) {
    return Hito(
      id: id,
      placeId: data['placeId'] ?? '',
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      descripcionWiki: data['descripcionWiki'] ?? '',
      descripcionWiki: data['descripcionWiki'] ?? '', 
      direccion: data['direccion'] ?? '',
      tipos: data['tipos'] ?? '',
      estado: data['estado'] ?? '',
      lat: (data['lat'] ?? 0).toDouble(),
      lng: (data['lng'] ?? 0).toDouble(),
      fotos: List<String>.from(data['fotos'] ?? []),
      urlMaps: data['urlMaps'] ?? '',
      accesible: data['accesible'] ?? false,
      iconUrl: data['iconUrl'] ?? '',
      tipo: data['tipo'] ?? 'hito',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'nombre': nombre,
      'descripcion': descripcion,
      'descripcionWiki': descripcionWiki,
      'descripcionWiki': descripcionWiki, 
      'direccion': direccion,
      'tipos': tipos,
      'estado': estado,
      'lat': lat,
      'lng': lng,
      'fotos': fotos,
      'urlMaps': urlMaps,
      'accesible': accesible,
      'iconUrl': iconUrl,
      'tipo': tipo,
    };
  }

  factory Hito.fromPlaces(
    Map<String, dynamic> place, {
    String wikiResumen = '',
  }) {
  factory Hito.fromPlaces(Map<String, dynamic> place, {String wikiResumen = ''}) {
    final location = place['geometry']['location'];
    final photos = place['photos'] as List?;
    final types = place['types'] as List?;

    final List<String> listaFotos = photos != null
        ? photos
              .map((p) => p['photo_reference'] as String? ?? '')
              .where((ref) => ref.isNotEmpty)
              .toList()
            .map((p) => p['photo_reference'] as String? ?? '')
            .where((ref) => ref.isNotEmpty)
            .toList()
        : [];

    return Hito(
      id: '',
      placeId: place['place_id'] ?? '',
      nombre: place['name'] ?? 'Sin nombre',
      descripcion: place['vicinity'] ?? 'Sin descripción',
      descripcionWiki: wikiResumen,
      direccion:
          place['formatted_address'] ?? place['vicinity'] ?? 'Sin dirección',
      descripcionWiki: wikiResumen, 
      direccion: place['formatted_address'] ?? place['vicinity'] ?? 'Sin dirección',
      tipos: types != null ? types.join(', ') : 'Sin clasificación',
      estado: place['business_status'] ?? '',
      lat: (location['lat'] ?? 0).toDouble(),
      lng: (location['lng'] ?? 0).toDouble(),
      fotos: listaFotos,
      urlMaps: place['url'] ?? '',
      accesible: place['wheelchair_accessible_entrance'] ?? false,
      iconUrl: place['icon'] ?? '',
      tipo: 'hito',
    );
  }
}
}
