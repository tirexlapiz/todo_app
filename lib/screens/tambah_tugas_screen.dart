import 'package:flutter/material.dart';

import 'package:todo_app/controller/tambah_tugas_controller.dart';

class TambahTugasScreen extends StatefulWidget {
  const TambahTugasScreen({super.key});

  @override
  State<TambahTugasScreen> createState() => _TambahTugasScreenState();
}

class _TambahTugasScreenState extends State<TambahTugasScreen> {
  late TambahTugasController controller;

  @override
  void initState() {
    super.initState();

    controller = TambahTugasController();

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  // ==========================================================
  // SIMPAN
  // ==========================================================

  Future<void> simpanTugas() async {
    if (controller.namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tugas belum diisi')));

      return;
    }

    final berhasil = await controller.simpanTugas();

    if (!mounted) return;

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil ditambahkan 🐰')),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8FA),

        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF40343A),
            size: 21,
          ),
        ),

        title: const Text(
          'Tambah Tugas',
          style: TextStyle(
            color: Color(0xFF30272C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // BUNNY HEADER
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD9E7), Color(0xFFF1D8EE)],
                ),

                borderRadius: BorderRadius.circular(25),

                border: Border.all(color: const Color(0xFFFFC3D3)),
              ),

              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white,

                      border: Border.all(
                        color: const Color(0xFFFFAFC4),
                        width: 2,
                      ),
                    ),

                    child: const Center(
                      child: Text('🐰', style: TextStyle(fontSize: 34)),
                    ),
                  ),

                  const SizedBox(width: 13),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Tugas baru? ✨',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF40343A),
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Yuk catat tugasmu supaya tidak lupa!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF806B74),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // NAMA TUGAS
            // ==================================================
            const Text(
              'Nama Tugas',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30272C),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: controller.namaController,

              textInputAction: TextInputAction.next,

              decoration: InputDecoration(
                hintText: 'Contoh: Belajar Flutter',

                prefixIcon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFFFF5D83),
                ),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),

                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),

                  borderSide: const BorderSide(color: Color(0xFFF1DCE2)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),

                  borderSide: const BorderSide(
                    color: Color(0xFFFF6A8D),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // DESKRIPSI
            // ==================================================
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30272C),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: controller.deskripsiController,

              maxLines: 5,

              decoration: InputDecoration(
                hintText: 'Tulis detail tugas di sini...',

                alignLabelWithHint: true,

                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 72),
                  child: Icon(Icons.notes_outlined, color: Color(0xFFFF5D83)),
                ),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),

                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),

                  borderSide: const BorderSide(color: Color(0xFFF1DCE2)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(17),

                  borderSide: const BorderSide(
                    color: Color(0xFFFF6A8D),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // KATEGORI
            // ==================================================
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF30272C),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(17),

                border: Border.all(color: const Color(0xFFF1DCE2)),
              ),

              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.kategori,

                  isExpanded: true,

                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFFFF5D83),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 'Belajar',
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 20,
                            color: Color(0xFF8060A8),
                          ),
                          SizedBox(width: 10),
                          Text('Belajar'),
                        ],
                      ),
                    ),

                    DropdownMenuItem(
                      value: 'Tugas Kuliah',
                      child: Row(
                        children: [
                          Icon(
                            Icons.school_rounded,
                            size: 20,
                            color: Color(0xFFD95778),
                          ),
                          SizedBox(width: 10),
                          Text('Tugas Kuliah'),
                        ],
                      ),
                    ),

                    DropdownMenuItem(
                      value: 'Kerjaan',
                      child: Row(
                        children: [
                          Icon(
                            Icons.work_rounded,
                            size: 20,
                            color: Color(0xFF67678F),
                          ),
                          SizedBox(width: 10),
                          Text('Kerjaan'),
                        ],
                      ),
                    ),
                  ],

                  onChanged: controller.ubahKategori,
                ),
              ),
            ),

            const SizedBox(height: 35),

            // ==================================================
            // TOMBOL SIMPAN
            // ==================================================
            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed: controller.isLoading ? null : simpanTugas,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5D83),

                  foregroundColor: Colors.white,

                  elevation: 3,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: controller.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(Icons.add_task_rounded, size: 22),

                          SizedBox(width: 8),

                          Text(
                            'Simpan Tugas',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
