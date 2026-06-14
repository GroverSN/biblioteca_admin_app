import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/libros_screen.dart';
import 'screens/usuarios_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Estado global en memoria para el Dark Mode
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Biblioteca',
      debugShowCheckedModeBanner: false,
      // Configuración de los dos temas nativos
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      initialRoute: '/',
      // Pasamos el estado y la función a las pantallas que lo requieran
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => HomeScreen(
              isDarkMode: _isDarkMode,
              onThemeChanged: _toggleTheme,
            ),
          );
        }
        if (settings.name == '/libros') {
          return MaterialPageRoute(builder: (context) => const LibrosScreen());
        }
        if (settings.name == '/usuarios') {
          return MaterialPageRoute(builder: (context) => const UsuariosScreen());
        }
        return null;
      },
    );
  }
}