import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NoteService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    return _auth.currentUser?.uid ?? '';
  }

  
  Future<void> crearNota(Note note) async {
    final noteRef = _database.ref("users/$_userId/notes").push();
    await noteRef.set({
      'titulo': note.titulo,
      'descripcion': note.descripcion,
      'precio': note.precio,
    });
  }

  Future<List<Note>> obtenerNotas() async {
    final noteRef = _database.ref("users/$_userId/notes");
    final snapshot = await noteRef.get();

    final notesMap = snapshot.value as Map<dynamic, dynamic>?;
    List<Note> notes = [];
    if (notesMap != null) {
      notesMap.forEach((key, value) {
        notes.add(Note.fromMap(Map<String, dynamic>.from(value), id: key));
      });
    }
    return notes;
  }

  Future<void> actualizarNota(Note note) async {
    final noteRef = _database.ref("users/$_userId/notes/${note.id}");
    await noteRef.update({
      'titulo': note.titulo,
      'descripcion': note.descripcion,
      'precio': note.precio,
    });
  }

  Future<void> eliminarNota(String id) async {
    final noteRef = _database.ref("users/$_userId/notes/$id");
    await noteRef.remove();
  }
}
