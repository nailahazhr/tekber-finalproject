import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMakananScreen extends StatefulWidget {
  final String makananId;
  final Map<String, dynamic> makananData;

  const UpdateMakananScreen({
    Key? key,
    required this.makananId,
    required this.makananData,
  }) : super(key: key);

  @override
  State<UpdateMakananScreen> createState() => _UpdateMakananScreenState();
}

class _UpdateMakananScreenState extends State<UpdateMakananScreen> {
  final CollectionReference makananRef =
      FirebaseFirestore.instance.collection('makanan');
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Makanan Baru'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari makanan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Hasil Pencarian
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: makananRef
                  .orderBy('nama_makanan')
                  .startAt([capitalizeEachWord(searchQuery)]).endAt(
                      ['${capitalizeEachWord(searchQuery)}\uf8ff']).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Terjadi kesalahan'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada makanan ditemukan'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var makanan = snapshot.data!.docs[index];
                    return ListTile(
                      leading: const Icon(Icons.fastfood),
                      title: Text(makanan['nama_makanan']),
                      subtitle: Text('${makanan['karbohidrat']} g karbohidrat'),
                      onTap: () => _updateMakanan(makanan.reference),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Future<void> _updateMakanan(DocumentReference newMakananRef) async {
    try {
      // Update dokumen di collection nutrisiPengguna
      await FirebaseFirestore.instance
          .collection('nutrisiPengguna')
          .doc(widget.makananId)
          .update({
        'id': newMakananRef, // Referensi ke makanan baru yang dipilih
        'tgl_update': DateTime.now(),
      });

      // Tampilkan pesan sukses
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil diperbarui!')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      // Tampilkan pesan error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui makanan: $e')),
      );
    }
  }
}
