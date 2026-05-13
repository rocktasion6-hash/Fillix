import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_crud_controller.dart';

class AdminCrudView extends GetView<AdminCrudController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEdit.value ? "Edit Film" : "Tambah Film"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.judulController,
              decoration: InputDecoration(labelText: "Judul Film", border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.kategoriController,
              decoration: InputDecoration(labelText: "Kategori/Genre", border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.posterController,
              decoration: InputDecoration(labelText: "URL Gambar Poster", border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.ringkasanController,
              maxLines: 3,
              decoration: InputDecoration(labelText: "Ringkasan", border: OutlineInputBorder()),
            ),
            TextField(
  controller: controller.sampulController,
  decoration: InputDecoration(labelText: "URL Gambar Sampul", border: OutlineInputBorder()),
),
SizedBox(height: 15),

TextField(
  controller: controller.ratingController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: "Skor Rating (Angka)", border: OutlineInputBorder()),
),
SizedBox(height: 15),

TextField(
  controller: controller.rilisController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(labelText: "Tanggal Rilis (Timestamp)", border: OutlineInputBorder()),
),
SizedBox(height: 15),

TextField(
  controller: controller.trailerController,
  decoration: InputDecoration(labelText: "URL Trailer", border: OutlineInputBorder()),
),
            SizedBox(height: 30),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.saveFilm,
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15)),
                      child: Text(controller.isEdit.value ? "Update Film" : "Simpan Film"),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}