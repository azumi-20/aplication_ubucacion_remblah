import 'package:flutter/material.dart';
import '../state/map_state.dart';

class MapLayerPanel extends StatelessWidget {

  final MapState state;
  final Function(MapState) onChanged;

  const MapLayerPanel({
    super.key,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Capas del mapa",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _item("Tramos", () {
              onChanged(MapState(showTramos: true));
            }),

            _item("Hitos", () {
              onChanged(MapState(showHitos: true));
            }),

            _item("Eventos", () {
              onChanged(MapState(showEventos: true));
            }),

            _item("Emprendimientos", () {
              onChanged(MapState(showEmprendimientos: true));
            }),
          ],
        ),
      ),
    );
  }

  Widget _item(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.layers, size: 18),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
