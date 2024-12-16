import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../models/note.dart';
import '../screen/auth.dart';
import '../screen/nota_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NoteService _noteService = NoteService();
  List<Note> _notas = [];

  @override
  void initState() {
    super.initState();
    _cargarNotas();
  }

  Future<void> _cargarNotas() async {
    if (_auth.currentUser != null) {
      List<Note> notas = await _noteService.obtenerNotas();
      setState(() {
        _notas = notas;
      });
    }
  }

  Future<void> _eliminarNota(String id) async {
    await _noteService.eliminarNota(id);
    _cargarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return _auth.currentUser == null
        ? AuthPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Mis Notas'),
              backgroundColor: Colors.blueAccent,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await _auth.signOut();
                    setState(() {});
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _notas.isEmpty
                  ? Center(
                      child: Text(
                        'No tienes notas guardadas',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notas.length,
                      itemBuilder: (context, index) {
                        final note = _notas[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              note.titulo,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${note.descripcion}\n\$${note.precio}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotaFormPage(note: note),
                                      ),
                                    );
                                    if (result == true) {
                                      _cargarNotas();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    _eliminarNota(note.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotaFormPage()),
                );
                if (result == true) {
                  _cargarNotas();
                }
              },
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.add),
            ),
          );
  }
}
