import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditDeleteScreen extends StatefulWidget {
  final String foodId;
  final Map<String, dynamic> foodData;

  const EditDeleteScreen({Key? key, required this.foodId, required this.foodData}) : super(key: key);

  @override
  _EditDeleteScreenState createState() => _EditDeleteScreenState();
}

class _EditDeleteScreenState extends State<EditDeleteScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.foodData['nama_makanan'] ?? '';
    selectedDate = widget.foodData['tgl_makan'] != null
        ? DateTime.parse(widget.foodData['tgl_makan'])
        : DateTime.now();
  }

  // Method untuk memperbarui data makanan
  Future<void> updateFoodData() async {
    try {
      await FirebaseFirestore.instance.collection('nutrisiPengguna').doc(widget.foodId).update({
        'nama_makanan': _nameController.text,
        'time': FieldValue.serverTimestamp(), // Menambahkan waktu saat update
        'tgl_makan': selectedDate?.toIso8601String(), // Menambahkan tanggal makan
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil diperbarui')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui data: $e')));
    }
  }

  // Method untuk menghapus makanan
  Future<void> deleteFoodData() async {
    try {
      await FirebaseFirestore.instance.collection('nutrisiPengguna').doc(widget.foodId).delete();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data berhasil dihapus')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus data: $e')));
    }
  }

  // Fungsi untuk memilih tanggal makan
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit/Delete Makanan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Makanan'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Tanggal Makan: ${selectedDate?.toLocal().toString().split(' ')[0]}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: updateFoodData,
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: deleteFoodData,
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
