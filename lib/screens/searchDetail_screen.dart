import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchDetailScreen extends StatefulWidget {
  final String makananId;
  final Map<String, dynamic> makananData;

  const SearchDetailScreen({
    super.key, 
    required this.makananId,
    required this.makananData,
  });

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  String imageUrl = '';
  int? selectedKategori;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    try {
      DocumentSnapshot makananDoc = await FirebaseFirestore.instance
          .collection('makanan')
          .doc(widget.makananId)
          .get();

      if (makananDoc.exists) {
        setState(() {
          imageUrl = makananDoc.get('img') ?? '';
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error mengambil URL gambar: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, StateSetter setStateDialog) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setStateDialog(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> tambahNutrisiPengguna(int kategori) async {
    try {
      DocumentReference makananRef = FirebaseFirestore.instance
          .collection('makanan')
          .doc(widget.makananId);

      await FirebaseFirestore.instance.collection('nutrisiPengguna').add({
        'id': makananRef,
        'tag': kategori,
        'time': DateTime.now(),
        'tgl_makan': selectedDate,
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data nutrisi berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
      
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan data: $e'),
          backgroundColor: Colors.red,
        ),
      );
      rethrow;
    }
  }

  Widget _image() {
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Text(
                    'Gambar makanan gagal ditampilkan',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : const Center(
                child: Text(
                  'Menampilkan gambar...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _infoGizi() {
    List<String> titles = ['Kalori', 'Karbohidrat', 'Protein', 'Lemak', 'Gula', 'Garam'];
    List<String> values = [
      '${widget.makananData['kalori']} ${widget.makananData['satuanKalori'] ?? 'kcal'}',
      '${widget.makananData['karbohidrat']} ${widget.makananData['satuanKarbohidrat'] ?? 'g'}',
      '${widget.makananData['protein']} ${widget.makananData['satuanProtein'] ?? 'g'}',
      '${widget.makananData['lemak']} ${widget.makananData['satuanLemak'] ?? 'g'}',
      '${widget.makananData['gula']} ${widget.makananData['satuanGula'] ?? 'g'}',
      '${widget.makananData['garam']} ${widget.makananData['satuanGaram'] ?? 'g'}',
    ];

    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            'Informasi Nilai Gizi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tThirdColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 20),
        for (int i = 0; i < titles.length; i += 3)...[
          Card(
            color: const Color(0xFFF0FFF0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: i == 0 ? 28 : 40,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int j = i; j < i + 3 && j < titles.length; j++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          titles[j],
                          style: const TextStyle(
                            color: tPrimaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          values[j],
                          style: const TextStyle(
                            color: tThirdColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (i < titles.length - 3) const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Tambah Makanan'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
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
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedKategori == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Silakan pilih kategori terlebih dahulu'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  tambahNutrisiPengguna(selectedKategori!);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2
            )
          ],
          color: tThirdColor
        ),
        child: const Text(
          'Tambah',
          style: TextStyle(fontSize: 20, color: tWhiteColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _Label() {
    return InkWell(
      // onTap: () {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => LoginPage()));
      // },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tambah',
              style: TextStyle(color: tGreyColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              'Poin',
              style: TextStyle(
                  color: tSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              ', Nikmati Langganan Premium!',
              style: TextStyle(color: tGreyColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.makananData['nama_makanan'] ?? '', 
          style: const TextStyle(
            color: tThirdColor,
            fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Gambar
              _image(),
              const SizedBox(height: 24),
              _infoGizi(),
              const SizedBox(height: 30),
              _submitButton(),
              _Label(),
            ],
          ),
        ),
      ),
    );
  }
}
