import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaMakananController;
  late TextEditingController _karbohidratController;

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data yang sudah ada
    _namaMakananController = TextEditingController(text: widget.makananData['nama_makanan']);
    _karbohidratController = TextEditingController(text: widget.makananData['karbohidrat'].toString());
  }

  Future<void> updateMakanan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('makanan').doc(widget.makananId).update({
          'nama_makanan': _namaMakananController.text,
          'karbohidrat': int.parse(_karbohidratController.text),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data makanan berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Kembali setelah berhasil update
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data Makanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaMakananController,
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama makanan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _karbohidratController,
                decoration: const InputDecoration(
                  labelText: 'Karbohidrat (g)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Karbohidrat tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Karbohidrat harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: updateMakanan,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
