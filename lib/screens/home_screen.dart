import 'package:flutter/material.dart';

import 'package:todo_app/controller/home_controller.dart';
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

  // ==========================================================
  // BUKA TAMBAH TUGAS
  // ==========================================================

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

  // ==========================================================
  // ICON KATEGORI
  // ==========================================================

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

  // ==========================================================
  // CHIP KATEGORI
  // ==========================================================

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
          color: aktif ? const Color(0xFFFF5D83) : const Color(0xFFFFF1F5),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: aktif ? const Color(0xFFFF5D83) : const Color(0xFFF0D9E1),
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            if (kategori != 'Semua')
              Icon(
                iconKategori(kategori),
                size: 14,

                color: aktif ? Colors.white : const Color(0xFF6D5660),
              ),

            if (kategori != 'Semua') const SizedBox(width: 5),

            Text(
              '$kategori ($jumlah)',

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,

                color: aktif ? Colors.white : const Color(0xFF5E4A53),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CARD TUGAS
  // ==========================================================

  Widget cardTugas(dynamic todo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(27),

        border: Border.all(
          color: todo.isCompleted
              ? const Color(0xFFEADDE2)
              : const Color(0xFFFFD6E1),

          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF789A).withOpacity(0.07),

            blurRadius: 12,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          // ==================================================
          // CHECKBOX
          // ==================================================
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
                    ? const Color(0xFFFF5D83)
                    : Colors.transparent,

                border: Border.all(color: const Color(0xFFFF668A), width: 2),
              ),

              child: todo.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // ==================================================
          // INFORMASI TUGAS
          // ==================================================
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
                        ? const Color(0xFFE8E0F6)
                        : todo.kategori == 'Tugas Kuliah'
                        ? const Color(0xFFFFDCE7)
                        : const Color(0xFFE1E1F1),

                    borderRadius: BorderRadius.circular(9),
                  ),

                  child: Text(
                    todo.kategori,

                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF66535C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // NAMA TUGAS
                Text(
                  todo.nama_tugas,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 14,

                    fontWeight: FontWeight.w600,

                    color: const Color(0xFF332A2F),

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

                      color: const Color(0xFF8B7780),

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
            icon: const Icon(Icons.more_vert, color: Color(0xFF66535C)),

            onSelected: (value) {
              if (value == 'hapus') {
                tampilkanDialogHapus(todo);
              }
            },

            itemBuilder: (context) {
              return const [
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
            '"${todo.nama_tugas}"?',
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
      backgroundColor: const Color(0xFFFFF8FA),

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8FA),

        elevation: 0,

        titleSpacing: 18,

        title: Row(
          children: [
            Container(
              width: 43,
              height: 43,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: const Color(0xFFFFE3EB),

                border: Border.all(color: const Color(0xFFFFB2C7)),
              ),

              child: const Center(
                child: Text('🐰', style: TextStyle(fontSize: 23)),
              ),
            ),

            const SizedBox(width: 10),

            const Text(
              'Bunny To-do',
              style: TextStyle(
                color: Color(0xFFB92E58),

                fontSize: 21,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: const [
          Icon(Icons.favorite, color: Color(0xFFFF5D83), size: 25),

          SizedBox(width: 20),

          Icon(Icons.notifications, color: Color(0xFF45373D), size: 24),

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
              'Hai Teman Bunny! 🐰',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30272C),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              controller.todos.isEmpty
                  ? 'Hari ini ada tugas yang menantimu!'
                  : 'Hari ini ada ${controller.todos.length} tugas yang menantimu!',

              style: const TextStyle(fontSize: 13, color: Color(0xFF806B74)),
            ),

            const SizedBox(height: 18),

            // =================================================
            // MOTIVASI BUNNY
            // =================================================
            Container(
              height: 108,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD9E7), Color(0xFFF0D7ED)],
                ),

                borderRadius: BorderRadius.circular(28),

                border: Border.all(color: const Color(0xFFFFC1D2)),
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
                        color: const Color(0xFFFFABC1),

                        width: 2,
                      ),
                    ),

                    child: const Center(
                      child: Text('🐰', style: TextStyle(fontSize: 36)),
                    ),
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
                        '“Yuk semangat, selesaikan tugasmu lalu makan wortel enak! 🥕”',

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF40363A),
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
                color: Color(0xFF30272C),
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
                    color: Color(0xFF30272C),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD7E2),

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text(
                    '${daftarTampil.length}',

                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD9416A),
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
                  child: CircularProgressIndicator(color: Color(0xFFFF5D83)),
                ),
              )
            // =================================================
            // KOSONG
            // =================================================
            else if (daftarTampil.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 45),

                child: Column(
                  children: [
                    Text('🐰', style: TextStyle(fontSize: 45)),

                    SizedBox(height: 10),

                    Text(
                      'Belum ada tugas',
                      style: TextStyle(color: Color(0xFF8B7780)),
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

        backgroundColor: const Color(0xFFFF5D83),

        elevation: 6,

        shape: const CircleBorder(),

        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
