import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/hito.dart';
import '../../data/api/google_places_api.dart';

class HitoDetailScreen extends StatefulWidget {
  final Hito hito;

  const HitoDetailScreen({super.key, required this.hito});

  @override
  State<HitoDetailScreen> createState() => _HitoDetailScreenState();
}

class _HitoDetailScreenState extends State<HitoDetailScreen> {
  int _fotoActual = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> fotosUrls =
        GooglePlacesApi.buildPhotoUrls(widget.hito.fotos);

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          /// CARRUSEL DE FOTOS
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.green,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: fotosUrls.isNotEmpty
                  ? Stack(
                      children: [
                        PageView.builder(
                          itemCount: fotosUrls.length,
                          onPageChanged: (index) =>
                              setState(() => _fotoActual = index),
                          itemBuilder: (context, index) {
                            return Image.network(
                              fotosUrls[index],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _imagenPlaceholder(),
                            );
                          },
                        ),
                        if (fotosUrls.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                fotosUrls.length,
                                (index) => AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  width: _fotoActual == index ? 16 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _fotoActual == index
                                        ? Colors.white
                                        : Colors.white54,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : _imagenPlaceholder(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// NOMBRE Y TIPO
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.hito.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          widget.hito.tipo.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// ESTADO DEL LUGAR
                  if (widget.hito.estado.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.hito.estado == 'OPERATIONAL'
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.hito.estado == 'OPERATIONAL'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      child: Text(
                        widget.hito.estado == 'OPERATIONAL'
                            ? '✓ Operativo'
                            : widget.hito.estado == 'CLOSED_TEMPORARILY'
                                ? '⚠ Cerrado temporalmente'
                                : '✕ Cerrado permanentemente',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: widget.hito.estado == 'OPERATIONAL'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  /// COORDENADAS
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.hito.lat.toStringAsFixed(5)}, '
                        '${widget.hito.lng.toStringAsFixed(5)}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),

                  /// ACCESIBLE
                  if (widget.hito.accesible) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(Icons.accessible,
                            size: 16, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          'Accesible para silla de ruedas',
                          style: TextStyle(
                              color: Colors.blue, fontSize: 13),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  /// DESCRIPCIÓN WIKIPEDIA — la más importante
                  if (widget.hito.descripcionWiki.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.auto_stories,
                                  size: 18, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Acerca de este lugar',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.hito.descripcionWiki,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// DESCRIPCIÓN DE PLACES
                  if (widget.hito.descripcion.isNotEmpty) ...[
                    _seccion(
                      icono: Icons.info_outline,
                      titulo: 'Descripción',
                      contenido: widget.hito.descripcion,
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// DIRECCIÓN
                  if (widget.hito.direccion.isNotEmpty) ...[
                    _seccion(
                      icono: Icons.directions_walk,
                      titulo: 'Dirección',
                      contenido: widget.hito.direccion,
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// TIPO DE LUGAR
                  if (widget.hito.tipos.isNotEmpty) ...[
                    _seccion(
                      icono: Icons.category_outlined,
                      titulo: 'Tipo de lugar',
                      contenido: widget.hito.tipos.replaceAll('_', ' '),
                    ),
                    const SizedBox(height: 32),
                  ],

                  /// BOTÓN ABRIR EN GOOGLE MAPS
                  if (widget.hito.urlMaps.isNotEmpty) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          final uri = Uri.parse(widget.hito.urlMaps);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        icon: const Icon(Icons.map, color: Colors.white),
                        label: const Text(
                          'Abrir en Google Maps',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  /// BOTÓN VOLVER
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.map_outlined,
                          color: Colors.white),
                      label: const Text(
                        'Volver al mapa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccion({
    required IconData icono,
    required String titulo,
    required String contenido,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 18, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          contenido,
          style: const TextStyle(
              fontSize: 14, height: 1.5, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _imagenPlaceholder() {
    return Container(
      color: Colors.green.shade100,
      child: const Center(
        child: Icon(Icons.landscape, size: 80, color: Colors.green),
      ),
    );
  }
}