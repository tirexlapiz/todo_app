class Todo {
  int? id;

  String namaTugas;

  String deskripsi;

  String kategori;

  bool isCompleted;

  Todo({
    this.id,
    required this.namaTugas,
    required this.deskripsi,
    required this.kategori,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_tugas': namaTugas,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      namaTugas: map['nama_tugas'],
      deskripsi: map['deskripsi'],
      kategori: map['kategori'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
