/*import 'package:flutter/material.dart';
import '../widgets/featured_map_card.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // APP BAR PERSONALIZADA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.cloud_done, size: 16, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          "OFFLINE READY",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Camino de los Sueños",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.account_circle, size: 28),
                ],
              ),
            ),

            // CONTENIDO SCROLL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HERO IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Image.network(
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuBS2RZRdHvVpPdrGhk4RxENSp_bae2h_NlA7ARIenScdoaMZjLIVfvoXzxqE2kGAbopgzREFUiDl1AjvU7NmecyKOXbgazopZRECNDF-cHkknlcX1A7vZgZTp0LBcOiY5HRQ4pTt5p0nxYZJEyAAG1QomJpZqsVMesbiNX9ztLNruBTtYpDz2jIRXST0S0l00DHivwym_EeQtS0tGeQfZs0vXAQeUhbVY1ZqrDw51mcUVOBCrpFxLu4NZwRvvjdQLvFsIlIaTkqv8Ss",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            color: Colors.black.withOpacity(0.4),
                            child: const Text(
                              "Valle de la Esperanza, Tramo 2",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Explora el Camino",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Tu guía comunitaria para el turismo rural",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    const FeaturedMapCard(),

                    const SizedBox(height: 28),

                    const Text(
                      "Explorar por Categoría",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: const [
                        CategoryCard(icon: Icons.route, title: "Tramos"),
                        CategoryCard(icon: Icons.map, title: "Mapa"),
                        CategoryCard(
                          icon: Icons.location_on,
                          title: "Hitos / QR",
                        ),
                        CategoryCard(icon: Icons.forest, title: "Comunidades"),
                        CategoryCard(icon: Icons.event, title: "Eventos"),
                        CategoryCard(icon: Icons.grid_view, title: "Más"),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Center(
                      child: Text(
                        "“230 km de historia, naturaleza y comunidad”",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Eventos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}

*/

//----------------------
import 'package:flutter/material.dart';
import 'package:my_secure_app/features/comunidad/screens/comunidad_screen.dart';
import 'package:my_secure_app/features/events/presentation/screens/events_screen.dart';

import 'package:my_secure_app/features/tramos/presentation/screens/tramos_screen.dart';
import 'package:my_secure_app/features/map/presentation/screens/map_screen.dart';

import '../widgets/featured_map_card.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MapScreen(), // Índice 0
      const HomeScreenContent(), // Índice 1
      const EventsScreen(), // Índice 2
      const Center(child: Text("Pantalla de Perfil")), // Índice 3
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF3A5F0B),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Eventos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildCustomAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(),
                  const SizedBox(height: 24),
                  const Text(
                    "Explora el Camino",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Tu guía comunitaria para el turismo rural",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const FeaturedMapCard(),
                  const SizedBox(height: 28),
                  const Text(
                    "Explorar por Categoría",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // GRID DE CATEGORÍAS
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      // 1. TRAMOS
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TramosScreen(),
                          ),
                        ),
                        child: const CategoryCard(
                          icon: Icons.route,
                          title: "Tramos",
                        ),
                      ),

                      // 2. MAPA
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MapScreen()),
                        ),
                        child: const CategoryCard(
                          icon: Icons.map,
                          title: "Mapa",
                        ),
                      ),

                      // 3. HITOS / QR
                      const CategoryCard(
                        icon: Icons.location_on,
                        title: "Hitos / QR",
                      ),

                      // 4. COMUNIDADES
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ComunidadScreen(),
                          ),
                        ),
                        child: const CategoryCard(
                          icon: Icons.forest,
                          title: "Comunidades",
                        ),
                      ),

                      // 5. EVENTOS
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EventsScreen(),
                          ),
                        ),
                        child: const CategoryCard(
                          icon: Icons.event,
                          title: "Eventos",
                        ),
                      ),

                      const CategoryCard(icon: Icons.grid_view, title: "Más"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "“230 km de historia, naturaleza y comunidad”",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AppBar personalizada con indicador de offline
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.cloud_done, size: 16, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "OFFLINE READY",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Text(
            "Camino de los Sueños",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.account_circle, size: 28),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1501854140801-50d01698950b",
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.black.withOpacity(0.4),
            child: const Text(
              "Valle de la Esperanza, Tramo 2",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
