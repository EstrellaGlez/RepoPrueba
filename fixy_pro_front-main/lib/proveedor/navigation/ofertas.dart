import 'package:fixypro/proveedor/screens/ofertasDetailsModal.dart';
import 'package:flutter/material.dart';

class OfertasScreen extends StatefulWidget {
  const OfertasScreen({super.key});

  @override
  State<OfertasScreen> createState() => _OfertasScreenState();
}

class _OfertasScreenState extends State<OfertasScreen> {
  final List<String> jobTypes = [
    'Carpintería',
    'Electricidad',
    'Jardinería',
    'Pintura',
    'Plomería',
  ];

  String query = '';
  List<String> filteredJobTypes = [];
  bool isAscending = true; // Controla el orden actual (A-Z o Z-A)

  @override
  void initState() {
    super.initState();
    filteredJobTypes = List.from(jobTypes);
  }

  void updateQuery(String newQuery) {
    setState(() {
      query = newQuery;
      _applyFilters();
    });
  }

  void _applyFilters() {
    filteredJobTypes = jobTypes
        .where((job) => job.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Ordenar según el estado actual (ascendente o descendente)
    if (isAscending) {
      filteredJobTypes.sort((a, b) => a.compareTo(b));
    } else {
      filteredJobTypes.sort((a, b) => b.compareTo(a));
    }
  }

  void toggleSortOrder() {
    setState(() {
      isAscending = !isAscending;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isLargeScreen = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quitar la flecha de navegación
        title: const Text(
          "FixyPro",
          style: TextStyle(
            color: Colors.white, // Texto en blanco
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF063852), // Fondo azul oscuro
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white, // Ícono en blanco
            ),
            onPressed: () {
              // Navegar al login
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Buscar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  )),
              onChanged: updateQuery,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.sort_by_alpha),
                tooltip: isAscending ? 'Ordenar Z-A' : 'Ordenar A-Z',
                onPressed: toggleSortOrder,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLargeScreen ? 4 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.5, // Tarjetas más largas
              ),
              itemCount: filteredJobTypes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showProblemDetailsModal(context);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          child: Image.asset(
                            'assets/images/descarga (3).jpg',
                            height: size.height * 0.2, // Imagen más grande
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: size.height * 0.2,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child:
                                    const Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredJobTypes[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isLargeScreen ? 20 : 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Descripción del trabajo aquí',
                                style: TextStyle(color: Colors.orange),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Detalles adicionales del trabajo.",
                                style: TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _showProblemDetailsModal(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF063852),
                            ),
                            child: const Text(
                              "Más información",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProblemDetailsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const OfeertaDetailsModal(),
    );
  }
}
