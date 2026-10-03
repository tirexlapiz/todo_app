import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/todo.dart';

class HomeController extends ChangeNotifier {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  // ==========================================================
  // DATA
  // ==========================================================

  List<Todo> todos = [];

  String kategoriDipilih = 'Semua';

  bool isLoading = false;

  // ==========================================================
  // KATEGORI
  // ==========================================================

  final List<String> daftarKategori = [
    'Semua',
    'Belajar',
    'Tugas Kuliah',
    'Kerjaan',
  ];

  // ==========================================================
  // LOAD DATA
  // ==========================================================

  Future<void> loadTodos() async {
    isLoading = true;
    notifyListeners();

    todos = await databaseHelper.getTodos();

    isLoading = false;
    notifyListeners();
  }

  // ==========================================================
  // FILTER KATEGORI
  // ==========================================================

  void pilihKategori(String kategori) {
    kategoriDipilih = kategori;

    notifyListeners();
  }

  List<Todo> get todosYangDitampilkan {
    if (kategoriDipilih == 'Semua') {
      return todos;
    }

    return todos.where((todo) {
      return todo.kategori == kategoriDipilih;
    }).toList();
  }

  // ==========================================================
  // JUMLAH KATEGORI
  // ==========================================================

  int jumlahKategori(String kategori) {
    if (kategori == 'Semua') {
      return todos.length;
    }

    return todos.where((todo) {
      return todo.kategori == kategori;
    }).length;
  }

  // ==========================================================
  // UBAH STATUS TUGAS
  // ==========================================================

  Future<void> ubahStatus(Todo todo) async {
    final todoBaru = Todo(
      id: todo.id,
      namaTugas: todo.namaTugas,
      deskripsi: todo.deskripsi,
      kategori: todo.kategori,
      isCompleted: !todo.isCompleted,
    );

    await databaseHelper.updateTodo(todoBaru);

    await loadTodos();
  }

  // ==========================================================
  // HAPUS TUGAS
  // ==========================================================

  Future<void> hapusTugas(Todo todo) async {
    if (todo.id == null) return;

    await databaseHelper.deleteTodo(todo.id!);

    await loadTodos();
  }

  // ==========================================================
  // JUMLAH TUGAS SELESAI
  // ==========================================================

  int get jumlahSelesai {
    return todos.where((todo) {
      return todo.isCompleted;
    }).length;
  }

  // ==========================================================
  // JUMLAH TUGAS BELUM SELESAI
  // ==========================================================

  int get jumlahBelumSelesai {
    return todos.where((todo) {
      return !todo.isCompleted;
    }).length;
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

}
