import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DeleteMakananScreen extends StatelessWidget {
  final String makananId;

  const DeleteMakananScreen({
    Key? key,
    required this.makananId,
  }) : super(key: key);

  Future<void> deleteMakanan(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('makanan').doc(makananId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data makanan berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Kembali ke screen sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Hapus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Apakah Anda yakin ingin menghapus data ini?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Batalkan penghapusan
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () => deleteMakanan(context), // Lakukan penghapusan
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Hapus'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
