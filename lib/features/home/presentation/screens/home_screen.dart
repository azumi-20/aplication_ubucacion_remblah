import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_secure_app/features/comunidad/screens/comunidad_screen.dart';
import 'package:my_secure_app/features/events/presentation/screens/events_screen.dart';
import 'package:my_secure_app/features/tramos/presentation/screens/tramos_screen.dart';
import 'package:my_secure_app/features/map/presentation/screens/map_screen.dart';
import 'package:my_secure_app/features/auth/presentation/pages/perfil_page.dart';
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
    _pages = const [
      MapScreen(),
      HomeScreenContent(),
      EventsScreen(),
      PerfilPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF3A5F0B),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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
          _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    "Tramos del Camino",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildTramosScroll(context),

                  const SizedBox(height: 24),

                  const Text(
                    "Explora el Camino",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const Text(
                    "Tu guía comunitaria para el turismo rural",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),

                  const SizedBox(height: 24),

                  _buildInteractiveMapCard(context),

                  const SizedBox(height: 32),

                  const Text(
                    "Explorar por Categoría",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    children: [
                      _buildCat(
                        context,
                        Icons.route,
                        "Tramos",
                        const TramosScreen(),
                      ),
                      _buildCat(
                        context,
                        Icons.map_outlined,
                        "Mapa",
                        const MapScreen(),
                      ),
                      _buildCat(
                        context,
                        Icons.location_on_outlined,
                        "Hitos",
                        const MapScreen(),
                      ),
                      _buildCat(
                        context,
                        Icons.forest_outlined,
                        "Comunidades",
                        const ComunidadScreen(),
                      ),
                      _buildCat(
                        context,
                        Icons.event,
                        "Eventos",
                        const EventsScreen(),
                      ),

                      GestureDetector(
                        onTap: () {},
                        child: const CategoryCard(
                          icon: Icons.grid_view,
                          title: "Más",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      "230 km de historia, naturaleza y comunidad",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
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

  // TOP BAR
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.cloud_done_outlined,
                      color: Colors.green,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "OFFLINE READY",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Camino de los Sueños",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Color(0xFFE0E0E0),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTramosScroll(BuildContext context) {
    return SizedBox(
      height: 180,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tramos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error cargando tramos"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No hay tramos disponibles"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TramosScreen()),
                ),
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(
                        data['imagen_url'] ?? "https://via.placeholder.com/300",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      data['nombre'] ?? "Tramo",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // MAPA INTERACTIVO
  Widget _buildInteractiveMapCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF3A5F0B),
            width: 2,
          ),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.map,
              color: Color(0xFF3A5F0B),
              size: 30,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Mapa Interactivo\nExplora 230 km de tramos y puntos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF3A5F0B),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCat(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: CategoryCard(
        icon: icon,
        title: title,
      ),
    );
  }
}
