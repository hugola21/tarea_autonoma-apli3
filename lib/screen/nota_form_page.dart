import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NotaFormPage extends StatefulWidget {
  final Note? note;

  const NotaFormPage({super.key, this.note});

  @override
  _NotaFormPageState createState() => _NotaFormPageState();
}

class _NotaFormPageState extends State<NotaFormPage> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final NoteService _noteService = NoteService();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _tituloController.text = widget.note!.titulo;
      _descripcionController.text = widget.note!.descripcion;
      _precioController.text = widget.note!.precio.toString();
    }
  }

  void _guardarNota() async {
    final titulo = _tituloController.text;
    final descripcion = _descripcionController.text;
    final precio = double.tryParse(_precioController.text) ?? 0;

    if (titulo.isEmpty || descripcion.isEmpty || precio <= 0) {
      return;
    }

    if (widget.note == null) {
      final nuevaNota = Note(
        id: '',
        titulo: titulo,
        descripcion: descripcion,
        precio: precio,
      );
      await _noteService.crearNota(nuevaNota);
    } else {
      final updatedNote = Note(
        id: widget.note!.id,
        titulo: titulo,
        descripcion: descripcion,
        precio: precio,
      );
      await _noteService.actualizarNota(updatedNote);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Crear Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _precioController,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarNota,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text(widget.note == null ? 'Guardar Nota' : 'Actualizar Nota'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
