import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:ns_apps/model/product_model.dart';
import 'package:ns_apps/constants/product_data.dart'; 

class SearchdetailScreen extends StatefulWidget {
  const SearchdetailScreen({super.key});

  @override
  State<SearchdetailScreen> createState() => SearchdetailScreenState();
}

class SearchdetailScreenState extends State<SearchdetailScreen> {
  final GiziProduk data = giziProdukList[0];

  Widget _image() {
    return Container(
      height: 250,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: NetworkImage(data.imageUrl),
          fit: BoxFit.fill,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _infoGizi() {
  List<String> titles = ['Kalori', 'Karbohidrat', 'Protein', 'Lemak', 'Gula', 'Garam'];
  List<String> values = [
    '${data.kalori} ${data.satuanKalori}',
    '${data.karbohidrat} ${data.satuanKarbohidrat}',
    '${data.protein} ${data.satuanProtein}',
    '${data.lemak} ${data.satuanLemak}',
    '${data.gula} ${data.satuanGula}',
    '${data.garam} ${data.satuanGaram}',
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
          data.title, 
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
