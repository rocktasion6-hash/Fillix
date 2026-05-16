import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pesan_tiket_controller.dart';

class PesanTiketView extends StatelessWidget {
  const PesanTiketView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PesanTiketController>();
    const Color primaryBrown = Color(0xFF443127);
    const Color accentYellow = Color(0xFFFBE488);

    return Scaffold(
      backgroundColor: primaryBrown,
      appBar: AppBar(
        title: const Text('Pilih Kursi'),
        backgroundColor: primaryBrown,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Info Film & Pilih Tanggal
          Container(
            color: primaryBrown,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.film.judul ?? '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Pilih Tanggal
                TextField(
                  controller: controller.tanggalController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Pilih Tanggal Tayang',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon:
                        const Icon(Icons.calendar_today, color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: accentYellow),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                      builder: (context, child) => Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: accentYellow,
                            onPrimary: primaryBrown,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      controller.tanggalController.text =
                          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      controller.muatKursiTerpesan();
                    }
                  },
                ),
              ],
            ),
          ),

          // Layar Bioskop
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentYellow.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentYellow.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'LAYAR',
                  style: TextStyle(
                      color: accentYellow.withOpacity(0.8), fontSize: 11),
                ),
              ],
            ),
          ),

          // Grid Kursi
          Expanded(
            child: Obx(() {
              if (controller.isLoadingKursi.value) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFBE488)));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: controller.baris.map((baris) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          // Label baris
                          SizedBox(
                            width: 20,
                            child: Text(baris,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12)),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ...List.generate(5, (kolom) {
                                  final id = '$baris${kolom + 1}';
                                  return _KursiWidget(
                                    id: id,
                                    controller: controller,
                                    accentYellow: accentYellow,
                                  );
                                }),
                                const SizedBox(width: 16),
                                ...List.generate(5, (kolom) {
                                  final id = '$baris${kolom + 6}';
                                  return _KursiWidget(
                                    id: id,
                                    controller: controller,
                                    accentYellow: accentYellow,
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ),

          // Legenda
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem(Colors.grey.shade700, 'Tersedia'),
                const SizedBox(width: 20),
                _legendItem(const Color(0xFFFBE488), 'Dipilih'),
                const SizedBox(width: 20),
                _legendItem(Colors.red.shade900, 'Terpesan'),
              ],
            ),
          ),

          // Bottom Bar
          Container(
            color: primaryBrown,
            padding: const EdgeInsets.all(16),
            child: Obx(() => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.kursiDipilih.length} Kursi dipilih',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          controller.kursiDipilih.isEmpty
                              ? '-'
                              : controller.kursiDipilih.join(', '),
                          style: const TextStyle(
                              color: Color(0xFFFBE488),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.pesanTiket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentYellow,
                          foregroundColor: primaryBrown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Color(0xFF443127))
                            : const Text('Pesan Tiket',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _KursiWidget extends StatelessWidget {
  final String id;
  final PesanTiketController controller;
  final Color accentYellow;

  const _KursiWidget({
    required this.id,
    required this.controller,
    required this.accentYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final terpesan = controller.kursiTerpesan.contains(id);
      final dipilih = controller.kursiDipilih.contains(id);

      Color bgColor;
      if (terpesan) {
        bgColor = Colors.red.shade900;
      } else if (dipilih) {
        bgColor = accentYellow;
      } else {
        bgColor = Colors.grey.shade700;
      }

      return GestureDetector(
        onTap: () => controller.toggleKursi(id),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(2),
            ),
          ),
          child: Center(
            child: Text(
              id,
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.bold,
                color: dipilih ? const Color(0xFF443127) : Colors.white70,
              ),
            ),
          ),
        ),
      );
    });
  }
}
