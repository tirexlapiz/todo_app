class Todo {
  int? id;

  String nama_tugas;

  String deskripsi;

  String kategori;

  bool isCompleted;

  Todo({
    this.id,
    required this.nama_tugas,
    required this.deskripsi,
    required this.kategori,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_tugas': nama_tugas,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      nama_tugas: map['nama_tugas'],
      deskripsi: map['deskripsi'],
      kategori: map['kategori'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
