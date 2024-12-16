class Note {
  String id;
  String titulo;
  String descripcion;
  double precio;

  Note({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.precio,
  });

  // Método para crear un objeto Note desde un mapa
  factory Note.fromMap(Map<String, dynamic> map, {required String id}) {
    return Note(
      id: id,
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      precio: map['precio'].toDouble(),
    );
  }

  // Método para convertir un objeto Note a un mapa
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'precio': precio,
    };
  }
}
