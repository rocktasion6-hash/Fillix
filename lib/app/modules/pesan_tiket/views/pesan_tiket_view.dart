import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pesan_tiket_controller.dart';

class PesanTiketView extends StatelessWidget {
  const PesanTiketView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PesanTiketController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Tiket'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.film.judul ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.tanggalController,
              decoration: const InputDecoration(
                labelText: 'Tanggal Tayang',
                hintText: 'Contoh: 2025-08-01',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.jumlahKursiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Kursi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event_seat),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.pesanTiket,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Pesan Sekarang', style: TextStyle(fontSize: 16)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
