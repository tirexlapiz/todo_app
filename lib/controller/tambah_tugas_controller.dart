import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/todo.dart';

class TambahTugasController extends ChangeNotifier {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

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

    try {
      isLoading = true;
      notifyListeners();

      final todo = Todo(
        nama_tugas: namaController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        kategori: kategori,
        isCompleted: false,
      );

      await databaseHelper.insertTodo(todo);

      return true;
    } catch (e) {
      debugPrint('ERROR SIMPAN TUGAS: $e');
      return false;
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
