import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    // Disparar la animación de entrada después del primer renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final primaryColor = isDark ? Colors.blueGrey[800]! : const Color(0xFF1E3A8A);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Biblioteca', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Icono Dinámico e Indicador Slider para Dark Mode
          Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
            activeThumbColor: Colors.amber,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido, Administrador',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // TABLEROS ANIMADOS (Efecto de deslizamiento y opacidad hacia arriba)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _animate ? 1.0 : 0.0,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 600),
                  padding: EdgeInsets.only(top: _animate ? 0.0 : 20.0),
                  child: Row(
                    children: [
                      _buildDashboardCard('Libros', '420', Icons.menu_book, Colors.blue, isDark),
                      const SizedBox(width: 16),
                      _buildDashboardCard('Personal', '8', Icons.badge, Colors.green, isDark),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const Text('Accesos Directos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // BOTONES DE ACCESO CON ANIMACIÓN DE ENTRADA
              AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _animate ? 1.0 : 0.0,
                child: Column(
                  children: [
                    _buildMenuButton(
                      context,
                      title: 'Gestión de Inventario',
                      subtitle: 'Control de stock, altas y bajas de libros',
                      icon: Icons.inventory_2,
                      color: Colors.blue,
                      route: '/libros',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      context,
                      title: 'Gestión de Usuarios',
                      subtitle: 'Administración de personal auxiliar',
                      icon: Icons.people,
                      color: Colors.teal,
                      route: '/usuarios',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String count, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required Color color,
    required String route,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}