import 'package:flutter/material.dart';
import 'package:ns_apps/screens/home_page.dart';
import 'package:ns_apps/screens/signup_screen.dart';
import '../constants/colors.dart';
import '../constants/images.dart';

class LoginScreen extends StatefulWidget {  // Changed class name to LoginScreen
  const LoginScreen({super.key, this.title});

  final String? title;

  @override
  _LoginScreenState createState() => _LoginScreenState();  // Changed state class name
}

class _LoginScreenState extends State<LoginScreen> {  // Changed state class name

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: tFacebook,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15)),
              ),
              alignment: Alignment.centerRight,
              child: Image.asset(
                tFacebookIcon, // Sesuaikan path gambar sesuai lokasi asset
                width: 25,
                height: 25,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: tFacebook,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              alignment: Alignment.center,
              child: const Text('Masuk Dengan Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: tGreyColorLine, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              alignment: Alignment.centerRight,
              child: Image.asset(
                tGoogleIcon,
                width: 25,
                height: 25,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'Masuk Dengan Google',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('atau'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: tGreyColorLine,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget _entryFieldLogin(String title, {bool isPassword = false, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: tGreyColor),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon) : null,
              fillColor: tWhiteColor, // Menggunakan tWhiteColor untuk warna latar
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: tGreyColorLine, width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: tGreyColorLine, width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to HomeScreen after login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
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
          'Masuk',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Belum memiliki akun ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: tGreyColor),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: const Text(
              'Daftar',
              style: TextStyle(
                  color: tSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }


  Widget _title() {
    return Container(
      child: const Text(
        "NutriSmart",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40,
          color: tPrimaryColor,
          fontFamily: "Nunito",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFieldLogin("Alamat Email", icon: Icons.account_circle_outlined),
        _entryFieldLogin("Kata Sandi", isPassword: true, icon: Icons.lock_outline),
      ],
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
                      const SizedBox(height: 30),
                      _facebookButton(),
                      _googleButton(),
                      _divider(),
                      _emailPasswordWidget(),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: const Text('Lupa Sandi?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500, color: tSecondaryColor)),
                      ),
                      const SizedBox(height: 20),
                      _submitButton(),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
