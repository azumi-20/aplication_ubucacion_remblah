import 'package:flutter/material.dart';

enum MarkerType {
  tramo,
  hito,
  emprendimiento,
  evento,
}

class MapMarkerWidget extends StatelessWidget {
  final MarkerType type;
  final VoidCallback? onTap;

  const MapMarkerWidget({
    super.key,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case MarkerType.tramo:
        icon = Icons.terrain;
        color = Colors.brown;
        break;
      case MarkerType.hito:
        icon = Icons.location_on;
        color = Colors.red;
        break;
      case MarkerType.emprendimiento:
        icon = Icons.store;
        color = Colors.blue;
        break;
      case MarkerType.evento:
        icon = Icons.event;
        color = Colors.green;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Colors.black26,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
