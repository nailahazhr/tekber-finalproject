import 'package:flutter/material.dart';
import 'package:ns_apps/data_to_cloud/clsNutrisi.dart';
import 'package:ns_apps/data_to_cloud/srvcNutrisi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PageAddMakan extends StatefulWidget {
  const PageAddMakan({super.key});

  @override
  State<PageAddMakan> createState() => _PageAddMakanState();
}

class _PageAddMakanState extends State<PageAddMakan> {
  // Text Controllers
  final TextEditingController textNama = TextEditingController();
  final TextEditingController textKategori = TextEditingController();

  // Service
  final Srvcnutrisi srvcNutrisi = Srvcnutrisi();

  // Fungsi untuk menambahkan makanan
  Future<void> _tambahMakan() async {
    // Periksa koneksi internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Menampilkan pesan kesalahan jika tidak ada koneksi internet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada koneksi internet!')),
      );
      return;
    }

    String nama = textNama.text.trim();
    String kategori = textKategori.text.trim();

    if (nama.isEmpty || kategori.isEmpty) {
      // Menampilkan pesan kesalahan jika ada field kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan kategori makanan harus diisi!')),
      );
      return;
    }

    ClsNutrisi makan = ClsNutrisi(
      nama: nama,
      kategori: kategori,
      tglDibuat: DateTime.now(),
    );

    // Asumsi bahwa addMakan adalah fungsi asinkron
    try {
      await srvcNutrisi.addMakan(makan);
      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil ditambahkan!')),
      );
      // Reset teks input setelah berhasil
      textNama.clear();
      textKategori.clear();
    } catch (e) {
      // Menampilkan pesan error jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan makanan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menambahkan Scaffold sebagai Material ancestor
      appBar: AppBar(
        title: const Text('Tambah Makanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                // Nama makanan
                TextField(
                  controller: textNama,
                  decoration: const InputDecoration(
                      label: Text("Masukkan nama makanan")),
                ),
                const SizedBox(height: 8), // Menambahkan jarak antar input

                // Kategori makanan
                TextField(
                  controller: textKategori,
                  decoration: const InputDecoration(
                      label: Text("Masukkan kategori makanan")),
                ),
              ],
            ),
            const SizedBox(height: 16), // Menambahkan jarak sebelum tombol

            // Tombol Submit
            ElevatedButton(
              onPressed: _tambahMakan,
              child: const Text("Tambah Makan"),
            ),
          ],
        ),
      ),
    );
  }
}
