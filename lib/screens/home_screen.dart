import 'package:flutter/material.dart';

import 'package:todo_app/controller/home_controller.dart';
import 'package:todo_app/models/todo.dart';
import 'tambah_tugas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;

  @override
  void initState() {
    super.initState();

    controller = HomeController();

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    controller.loadTodos();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<void> bukaTambahTugas() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const TambahTugasScreen();
        },
      ),
    );

    if (hasil == true) {
      await controller.loadTodos();
    }
  }

  Future<void> bukaEditTugas(Todo todo) async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TambahTugasScreen(todo: todo);
        },
      ),
    );

    if (hasil == true) {
      await controller.loadTodos();
    }
  }

  IconData iconKategori(String kategori) {
    if (kategori == 'Belajar') {
      return Icons.menu_book_rounded;
    }

    if (kategori == 'Tugas Kuliah') {
      return Icons.school_rounded;
    }

    if (kategori == 'Kerjaan') {
      return Icons.work_rounded;
    }

    return Icons.check_circle;
  }

  Widget kategoriChip(String kategori) {
    final bool aktif = controller.kategoriDipilih == kategori;

    final int jumlah = controller.jumlahKategori(kategori);

    return GestureDetector(
      onTap: () {
        controller.pilihKategori(kategori);
      },

      child: Container(
        margin: const EdgeInsets.only(right: 8),

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),

        decoration: BoxDecoration(
          color: aktif ? const Color(0xFF123B5D) : const Color(0xFFEAF5E9),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: aktif ? const Color(0xFF123B5D) : const Color(0xFFD4E8D4),
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            if (kategori != 'Semua')
              Icon(
                iconKategori(kategori),
                size: 14,

                color: aktif ? Colors.white : const Color(0xFF60798C),
              ),

            if (kategori != 'Semua') const SizedBox(width: 5),

            Text(
              '$kategori ($jumlah)',

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,

                color: aktif ? Colors.white : const Color(0xFF3D596F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardTugas(dynamic todo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(27),

        border: Border.all(
          color: todo.isCompleted
              ? const Color(0xFFDBE7DE)
              : const Color(0xFFD4EBD2),

          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF789F7A).withValues(alpha: 0.10),

            blurRadius: 12,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              controller.ubahStatus(todo);
            },

            child: Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: todo.isCompleted
                    ? const Color(0xFF123B5D)
                    : Colors.transparent,

                border: Border.all(color: const Color(0xFF123B5D), width: 2),
              ),

              child: todo.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // KATEGORI
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: todo.kategori == 'Belajar'
                        ? const Color(0xFFDCEEDC)
                        : todo.kategori == 'Tugas Kuliah'
                        ? const Color(0xFFCDECCF)
                        : const Color(0xFFE6F1E5),

                    borderRadius: BorderRadius.circular(9),
                  ),

                  child: Text(
                    todo.kategori,

                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF46604F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // NAMA TUGAS
                Text(
                  todo.namaTugas,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14,

                    fontWeight: FontWeight.w600,

                    color: const Color(0xFF1D3548),

                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                if (todo.deskripsi.isNotEmpty) const SizedBox(height: 3),

                if (todo.deskripsi.isNotEmpty)
                  Text(
                    todo.deskripsi,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 11,

                      color: const Color(0xFF60798C),

                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
              ],
            ),
          ),

          // ==================================================
          // MENU
          // ==================================================
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF46604F)),

            onSelected: (value) {
              if (value == 'edit') {
                bukaEditTugas(todo);
              } else if (value == 'hapus') {
                tampilkanDialogHapus(todo);
              }
            },

            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'hapus', child: Text('Hapus')),
              ];
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DIALOG HAPUS
  // ==========================================================

  void tampilkanDialogHapus(dynamic todo) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Tugas'),

          content: Text(
            'Yakin ingin menghapus '
            '"${todo.namaTugas}"?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await controller.hapusTugas(todo);
              },

              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final daftarTampil = controller.todosYangDitampilkan;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF2),

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4FAF2),

        elevation: 0,

        titleSpacing: 18,

        title: Row(
          children: [
            Container(
              width: 43,
              height: 43,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: const Color(0xFFE6F1E5),

                border: Border.all(color: const Color(0xFFCDECCF)),
              ),

              child: Center(child: Image.asset('lib/img/kucing.png')),
            ),

            const SizedBox(width: 10),

            const Text(
              'Neko To-do',
              style: TextStyle(
                color: Color(0xFF123B5D),

                fontSize: 21,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: const [
          Icon(Icons.favorite, color: Color(0xFF123B5D), size: 25),

          SizedBox(width: 20),

          Icon(Icons.notifications, color: Color(0xFF46604F), size: 24),

          SizedBox(width: 18),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 100),

          children: [
            const Text(
              'Hai Teman! 🐱',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3548),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              controller.todos.isEmpty
                  ? 'Hari ini ada tugas yang menantimu!'
                  : 'Hari ini ada ${controller.todos.length} tugas yang menantimu!',

              style: const TextStyle(fontSize: 13, color: Color(0xFF60798C)),
            ),

            const SizedBox(height: 18),

            // =================================================
            // MOTIVASI BUNNY
            // =================================================
            Container(
              height: 108,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDDF0DC), Color(0xFFCDECCF)],
                ),

                borderRadius: BorderRadius.circular(28),

                border: Border.all(color: const Color(0xFFB7DDB9)),
              ),

              child: Row(
                children: [
                  const SizedBox(width: 15),

                  Container(
                    width: 63,
                    height: 63,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white,

                      border: Border.all(
                        color: const Color(0xFFB7DDB9),

                        width: 2,
                      ),
                    ),

                    child: Center(child: Image.asset('lib/img/kucing.png')),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(22),
                      ),

                      child: const Text(
                        '“Yuk semangat, selesaikan tugasmu lalu bersantai! 🐱”',

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D3548),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // KATEGORI
            // =================================================
            const Text(
              'Kategori Tugas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3548),
              ),
            ),

            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  kategoriChip('Semua'),

                  kategoriChip('Belajar'),

                  kategoriChip('Tugas Kuliah'),

                  kategoriChip('Kerjaan'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =================================================
            // JUDUL DAFTAR
            // =================================================
            Row(
              children: [
                const Text(
                  'Daftar Tugas Harian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D3548),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFCDECCF),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text(
                    '${daftarTampil.length}',

                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123B5D),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =================================================
            // LOADING
            // =================================================
            if (controller.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),

                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF123B5D)),
                ),
              )
            // =================================================
            // KOSONG
            // =================================================
            else if (daftarTampil.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 45),

                child: Column(
                  children: [
                    Image.asset('lib/img/kucing.png', width: 60, height: 60),

                    const SizedBox(height: 10),

                    const Text(
                      'Belum ada tugas',
                      style: TextStyle(color: Color(0xFF60798C)),
                    ),
                  ],
                ),
              )
            // =================================================
            // DAFTAR TUGAS
            // =================================================
            else
              ...daftarTampil.map((todo) => cardTugas(todo)),
          ],
        ),
      ),

      // ======================================================
      // FLOATING BUTTON
      // ======================================================
      floatingActionButton: FloatingActionButton(
        onPressed: bukaTambahTugas,

        backgroundColor: const Color(0xFF123B5D),

        elevation: 6,

        shape: const CircleBorder(),

        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
