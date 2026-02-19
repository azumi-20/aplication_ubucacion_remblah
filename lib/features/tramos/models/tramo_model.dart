class TramoModel {
  final String id;
  final String nombre;
  final String distancia;
  final String dificultad;
  final String tiempo;
  final String imagenUrl;
  final String descripcion;
  final String desnivel;
  final List<Map<String, String>> puntosInteres;
  final double latInicio;
  final double lngInicio;
  final double latFin;
  final double lngFin;

  TramoModel({
    required this.id,
    required this.nombre,
    required this.distancia,
    required this.dificultad,
    required this.tiempo,
    required this.imagenUrl,
    this.descripcion = '',
    this.desnivel = '',
    this.puntosInteres = const [],
    this.latInicio = 0,
    this.lngInicio = 0,
    this.latFin = 0,
    this.lngFin = 0,
  });

  factory TramoModel.fromMap(String id, Map<String, dynamic> data) {
    final rawPuntos = data['puntos_interes'];
    final List<Map<String, String>> puntos = [];
    if (rawPuntos is List) {
      for (final item in rawPuntos) {
        if (item is Map) {
          puntos.add({
            'nombre': item['nombre']?.toString() ?? '',
            'tipo': item['tipo']?.toString() ?? '',
          });
        }
      }
    }

    return TramoModel(
      id: id,
      nombre: (data['nombre'] ?? 'Sin nombre').toString().replaceAll('"', ''),
      distancia: data['distancia']?.toString() ?? '0 km',
      dificultad: data['dificultad']?.toString() ?? 'N/A',
      tiempo: data['tiempo']?.toString() ?? '--',
      imagenUrl:
          (data['imagen_url'] != null &&
              data['imagen_url'].toString().isNotEmpty)
          ? data['imagen_url'].toString()
          : 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=800',
      descripcion: data['descripcion']?.toString() ?? '',
      desnivel: data['desnivel']?.toString() ?? '',
      puntosInteres: puntos,
      latInicio: (data['lat_inicio'] ?? 0).toDouble(),
      lngInicio: (data['lng_inicio'] ?? 0).toDouble(),
      latFin: (data['lat_fin'] ?? 0).toDouble(),
      lngFin: (data['lng_fin'] ?? 0).toDouble(),
    );
  }
}
