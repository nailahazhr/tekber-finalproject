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
  DateTime selectedDate = DateTime.now();
  int? selectedKategori;

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data yang sudah ada
    _namaMakananController = TextEditingController(text: widget.makananData['nama_makanan']);
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> updateMakanan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('makanan').doc(widget.makananId).update({
          'nama_makanan': _namaMakananController.text,
          'kategori': selectedKategori,
          'tanggal': selectedDate,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    isExpanded: true,
                    value: selectedKategori,
                    hint: const Text('Pilih kategori'),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Sarapan')),
                      DropdownMenuItem(value: 2, child: Text('Makan Siang')),
                      DropdownMenuItem(value: 3, child: Text('Makan Malam')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedKategori = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context, setState),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tanggal: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ],
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
