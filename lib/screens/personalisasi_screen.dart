import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/images.dart';
import 'package:ns_apps/screens/home_page.dart';

class PersonalisasiScreen extends StatefulWidget {
  const PersonalisasiScreen({super.key, this.title, required String name, required String firstName});

  final String? title;

  @override
  State<PersonalisasiScreen> createState() => _PersonalisasiScreenState();
}


class _PersonalisasiScreenState extends State<PersonalisasiScreen> {
  String? pilihJenisKelamin;
  List<String> jenisKelamin = ['Perempuan', 'Laki-Laki'];
  String? pilihAktivitas;
  List<String> jenisAktivitas = ['Sangat Ringan', 'Ringan', 'Sedang', 'Berat'];
  @override
  Widget _entryFieldPersonalisasi(
      String title, {
        bool isPassword = false,
        bool isDropdown = false,
        Image? prefixImage,
        List<String>? dropdownItems,
        String? selectedItem,
        ValueChanged<String?>? onChanged,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: tGreyColor,
            ),
          ),
          const SizedBox(height: 10),
          isDropdown && dropdownItems != null
              ? _buildDropdownField(
              prefixImage, dropdownItems, selectedItem, onChanged)
              : _buildTextField(prefixImage, isPassword),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
      Image? prefixImage,
      List<String> dropdownItems,
      String? selectedItem,
      ValueChanged<String?>? onChanged,
      ) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      onChanged: onChanged,
      items: dropdownItems.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: _inputDecoration(prefixImage),
    );
  }

  Widget _buildTextField(Image? prefixImage, bool isPassword) {
    return TextField(
      obscureText: isPassword,
      decoration: _inputDecoration(prefixImage),
    );
  }

  InputDecoration _inputDecoration(Image? prefixImage) {
    return InputDecoration(
      prefixIcon: prefixImage != null
          ? Container(
        width: 48,
        padding: const EdgeInsets.all(8),
        child: prefixImage,
      )
          : null,
      fillColor: tWhiteColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: tGreyColorLine, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: tGreyColorLine, width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }


  Widget _title() {
    return Container(
      child: const Text(
        "Personalisasi",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          color: tThirdColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _personalisasiWidget() {
    return Column(
      children: <Widget>[
        _entryFieldPersonalisasi(
          "Umur (tahun)",
          prefixImage: Image.asset(tUmurIcon),
        ),
        _entryFieldPersonalisasi(
          "Tinggi Badan (cm)",
          prefixImage: Image.asset(tTinggiBadanIcon),
        ),
        _entryFieldPersonalisasi(
          "Berat Badan (kg)",
          prefixImage: Image.asset(tBeratBadanIcon),
        ),
        _entryFieldPersonalisasi(
          "Jenis Kelamin",
          prefixImage: Image.asset(tJenisKelaminIcon),
          isDropdown: true,
          dropdownItems: jenisKelamin,
          selectedItem: pilihJenisKelamin,
          onChanged: (String? newValue) {
            setState(() {
              pilihJenisKelamin = newValue;
            });
          },
        ),
        _entryFieldPersonalisasi(
          "Jenis Aktivitas",
          prefixImage: Image.asset(tJenisAktivitasIcon),
          isDropdown: true,
          dropdownItems: jenisAktivitas,
          selectedItem: pilihAktivitas,
          onChanged: (String? newValue) {
            setState(() {
              pilihAktivitas = newValue;
            });
          },
        ),
      ],
    );
  }
  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage(firstName: '',)),
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
              spreadRadius: 2,
            ),
          ],
          color: tThirdColor,
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
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
              'Apakah sudah memiliki akun ?',
              style: TextStyle(color: tGreyColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Masuk',
              style: TextStyle(
                  color: tSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: tWhiteColor,
        body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .1),
                      _title(),
                      const Text(
                        'Bantu kami mengenal dirimu lebih baik',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: tGreyColor),
                      ),
                      const SizedBox(height: 30),
                      _personalisasiWidget(),
                      const SizedBox(height: 20),
                      _submitButton(),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
