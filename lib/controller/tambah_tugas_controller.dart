import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/todo.dart';

class TambahTugasController extends ChangeNotifier {
  TambahTugasController({Todo? todo}) : _todo = todo {
    if (todo != null) {
      namaController.text = todo.namaTugas;
      deskripsiController.text = todo.deskripsi;
      kategori = todo.kategori;
    }
  }

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  final Todo? _todo;

  // Controller untuk input
  final TextEditingController namaController = TextEditingController();

  final TextEditingController deskripsiController = TextEditingController();

  // Kategori default
  String kategori = 'Belajar';

  // Loading ketika menyimpan
  bool isLoading = false;

  // ==========================================================
  // UBAH KATEGORI
  // ==========================================================

  void ubahKategori(String? value) {
    if (value == null) return;

    kategori = value;

    notifyListeners();
  }

  // ==========================================================
  // SIMPAN TUGAS
  // ==========================================================

  Future<bool> simpanTugas() async {
    if (namaController.text.trim().isEmpty) {
      return false;
    }

    isLoading = true;
    notifyListeners();
    try {
      final todo = Todo(
        id: _todo?.id,
        namaTugas: namaController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        kategori: kategori,
        isCompleted: _todo?.isCompleted ?? false,
      );

      if (_todo == null) {
        await databaseHelper.insertTodo(todo);
      } else {
        await databaseHelper.updateTodo(todo);
      }

      return true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ==========================================================
  // RESET FORM
  // ==========================================================

  void resetForm() {
    namaController.clear();
    deskripsiController.clear();

    kategori = 'Belajar';

    notifyListeners();
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();

    super.dispose();
  }
}
