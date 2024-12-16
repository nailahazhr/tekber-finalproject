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
          print('URL Gambar: $imageUrl');
        });
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error mengambil URL gambar: $e');
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
                  'Gambar makanan gagal ditampilkan',
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          color: tThirdColor),
      child: const Text(
        'Tambah',
        style: TextStyle(fontSize: 20, color: tWhiteColor, fontWeight: FontWeight.bold),
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
        // padding: EdgeInsets.all(15),
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
          widget.makananData['title'] ?? '', 
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
