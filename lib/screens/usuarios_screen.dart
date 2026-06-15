import 'package:flutter/material.dart';
import 'package:biblioteca_admin_app/models/usuario.dart';
import '../widgets/usuario_card.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final List<Usuario> _allUsuarios = [
    Usuario(nombre: 'Grover Flores', rol: 'Administrador', id: 'ADM-01'),
    Usuario(nombre: 'Ana Martínez', rol: 'Auxiliar Técnico', id: 'AUX-02'),
    Usuario(nombre: 'Carlos Condori', rol: 'Auxiliar Técnico', id: 'AUX-03'),
  ];

  List<Usuario> _filteredUsuarios = [];
  final _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _idController = TextEditingController();
  String _selectedRol = 'Auxiliar Técnico';

  @override
  void initState() {
    super.initState();
    _filteredUsuarios = _allUsuarios;
  }

  void _filterUsuarios(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsuarios = _allUsuarios;
      } else {
        _filteredUsuarios = _allUsuarios;
            _allUsuarios.where((u) =>
              u.nombre.toLowerCase().contains(query.toLowerCase()) ||
              u.id.toLowerCase().contains(query.toLowerCase())
              ).toList();
      }
    });
  }

  void _runFilter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsuarios = List.from(_allUsuarios);
      } else {
        _filteredUsuarios = _allUsuarios
            .where((u) =>
                u.nombre.toLowerCase().contains(query.toLowerCase()) ||
                u.id.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _mostrarFormulario({int? index}) {
     if (index != null) {
        _nombreController.text = _filteredUsuarios[index].nombre;
        _idController.text = _filteredUsuarios[index].id;
        _selectedRol = _filteredUsuarios[index].rol;
     } else {
        _nombreController.clear();
        _idController.clear();
        _selectedRol = 'Auxiliar Técnico';
    }


    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(index == null ? 'Registrar Usuario' : 'Modificar Usuario'),
              content: SizedBox(
                width: 400, // Ancho amplio para que luzca perfecto en web y móviles
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true, // Se adapta limpiamente al contenido vertical
                    children: [
                      TextFormField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          labelText: 'ID / Código Personal', 
                          prefixIcon: Icon(Icons.badge),
                          contentPadding: EdgeInsets.symmetric(vertical: 16), // Mayor espacio interno
                        ),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16), // Espaciado entre campos
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre Completo', 
                          prefixIcon: Icon(Icons.person),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedRol,
                        decoration: const InputDecoration(
                          labelText: 'Rol Asignado', 
                          prefixIcon: Icon(Icons.shield),
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        items: ['Administrador', 'Auxiliar Técnico']
                            .map((rol) => DropdownMenuItem(value: rol, child: Text(rol)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              _selectedRol = value;
                            });
                            setState(() {
                              _selectedRol = value;
                            });
                          }
                        },
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
                    backgroundColor: Colors.teal, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        if (index == null) {
                          _allUsuarios.add(
                            Usuario(
                              id: _idController.text,
                              nombre: _nombreController.text,
                              rol: _selectedRol!,
                           ),
                         );
                        } else {
                          final originalIndex = _allUsuarios.indexOf(_filteredUsuarios[index!]);
                          _allUsuarios[originalIndex] = Usuario(
                            id: _idController.text,
                            nombre: _nombreController.text,
                            rol: _selectedRol!,
                          );
                        }
                        _filterUsuarios(_searchController.text);
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(index == null ? 'Registrar' : 'Actualizar'),
                ),
              ],
            );
          },
        );
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o ID...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsuarios.isEmpty
              ? const Center(child: Text('No hay usuarios que coincidan.'))
              : ListView.builder(
                itemCount: _filteredUsuarios.length,
                itemBuilder: (context, index) {
                  final usuario = _filteredUsuarios[index];
          
                  return UsuarioCard(
                    usuario: usuario,
                    onEdit: () => _mostrarFormulario(index: index),
                    onDelete: () {
                      setState(() {
                        final originalIndex = _allUsuarios.indexOf(usuario);
                        _allUsuarios.removeAt(originalIndex);
                        _runFilter(_searchController.text);
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}