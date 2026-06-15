import 'package:flutter/material.dart';
import 'package:biblioteca_admin_app/models/usuario.dart';

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
              onChanged: _filterUsuarios,
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
                      final isAdmin = usuario.rol == 'Administrador';

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: isAdmin ? Colors.red.withValues(alpha: 0.1) : Colors.teal.withValues(alpha: 0.1),
                            child: Icon(isAdmin ? Icons.supervisor_account : Icons.person, color: isAdmin ? Colors.red : Colors.teal),
                          ),
                          title: Text(usuario.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${usuario.id}'),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isAdmin 
                                      ? (isDark ? Colors.red[900]!.withValues(alpha: 0.3) : Colors.red[50]) 
                                      : (isDark ? Colors.teal[900]!.withValues(alpha: 0.3) : Colors.teal[50]),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  usuario.rol,
                                  style: TextStyle(
                                      color: isAdmin 
                                          ? (isDark ? Colors.red[200] : Colors.red[900]) 
                                          : (isDark ? Colors.teal[200] : Colors.teal[900]),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () => _mostrarFormulario(index: index)),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
                                  setState(() {
                                    _allUsuarios.remove(_filteredUsuarios[index]);
                                    _filterUsuarios(_searchController.text);
                                  });
                                },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}