import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../widgets/libro_card.dart';

class LibrosScreen extends StatefulWidget {
  const LibrosScreen({super.key});

  @override
  State<LibrosScreen> createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  final List<Libro> _allLibros = [
    Libro(codigo: 'LIB-01', titulo: 'Cien años de soledad', autor: 'Gabriel García Márquez'),
    Libro(codigo: 'LIB-02', titulo: 'Don Quijote de la Mancha', autor: 'Miguel de Cervantes'),
    Libro(codigo: 'LIB-03', titulo: 'El resplandor', autor: 'Stephen King'),
  ];

  List<Libro> _filteredLibros = [];
  final _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _codigoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredLibros = List.from(_allLibros); // Al inicio muestra todos
  }

  // Lógica interna de filtrado en memoria
  void _filterLibros(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLibros = _allLibros;
      } else {
        _filteredLibros = _allLibros
            .where((libro) =>
                libro.titulo.toLowerCase().contains(query.toLowerCase()) ||
                libro.autor.toLowerCase().contains(query.toLowerCase()))
            .toList();
    }
    });
  }

  void _mostrarFormulario({int? index}) {
    // Si pasamos un index, estamos EDITANDO, cargamos los datos previos
    if (index != null) {
      _tituloController.text = _filteredLibros[index].titulo;
      _autorController.text = _filteredLibros[index].autor;
      _codigoController.text = _filteredLibros[index].codigo;
    } else {
      _tituloController.clear();
      _autorController.clear();
      _codigoController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(index == null ? 'Agregar Nuevo Libro' : 'Editar Libro'),
        content: SizedBox(
          width: 400, // Ancho amplio para evitar compresión lateral
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true, // Se adapta perfectamente al alto del formulario
              children: [
                TextFormField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código / Signatura', 
                    prefixIcon: Icon(Icons.tag),
                    contentPadding: EdgeInsets.symmetric(vertical: 16), // Más espacio interno
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16), // Espaciado vertical holgado
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título del libro', 
                    prefixIcon: Icon(Icons.book),
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _autorController,
                  decoration: const InputDecoration(
                    labelText: 'Autor', 
                    prefixIcon: Icon(Icons.person),
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A), 
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  if (index == null) {
                  _allLibros.add(
                  Libro(
                    codigo: _codigoController.text,
                    titulo: _tituloController.text,
                    autor: _autorController.text,
                  ),
                );
              } else {
                  final originalIndex = _allLibros.indexOf(_filteredLibros[index!]);
                  _allLibros[originalIndex] = Libro(
                    codigo: _codigoController.text,
                    titulo: _tituloController.text,
                    autor: _autorController.text,
                  );
              }
                  _filterLibros(_searchController.text); // Refrescar filtro
                });
                Navigator.pop(context);
              }
            },
            child: Text(index == null ? 'Guardar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // CORRECCIÓN AQUÍ: Detectar dinámicamente si el modo oscuro está activo
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Fondo adaptativo inteligente para que cambie en modo dark
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Inventario de Libros'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Campo de Búsqueda Estilizado
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterLibros,
              decoration: InputDecoration(
                hintText: 'Buscar por título o autor...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                // Color adaptativo para el fondo del buscador
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Lista de Libros
          Expanded(
            child: _filteredLibros.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron libros.',
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredLibros.length,
                    itemBuilder: (context, index) {
                       final libro = _filteredLibros[index];
          
                      return LibroCard(
                        libro: libro,
                        onEdit: () => _mostrarFormulario(index: index),
                        onDelete: () {
                          setState(() {
                            _allLibros.remove(libro);
                            _filteredLibros.remove(libro); // Borrado síncrono seguro e inmediato
                          });
                        },
                      );
                    },
                  ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}