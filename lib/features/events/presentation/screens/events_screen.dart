import 'package:flutter/material.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          EventCard(
            title: "Festival del Café",
            location: "Valle Verde - Tramo 1",
            date: "15 Feb 2026",
            description:
                "Celebración anual del café con degustaciones y música tradicional.",
          ),
          SizedBox(height: 16),
          EventCard(
            title: "Caminata Nocturna",
            location: "Bosque Nuboso",
            date: "22 Feb 2026",
            description:
                "Observación de fauna nocturna con guías expertos.",
          ),
        ],
      ),
    );
  }
}
