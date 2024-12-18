import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ns_apps/constants/colors.dart';
import 'package:ns_apps/constants/images.dart';
import 'package:ns_apps/screens/login_screen.dart';
import 'package:ns_apps/screens/personalisasi_screen.dart';
import 'package:ns_apps/provider/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.title});

  final String? title;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Widget _entryFieldSignUp(String title,
      {bool isPassword = false, IconData? icon, TextEditingController? controller}) {
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
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon) : null,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () async {
        String name = _nameController.text.trim();
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        if (name.isEmpty || email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Semua kolom harus diisi")),
          );
          return;
        }

        // Ekstrak nama awal dari email
        String firstName = email.contains('@') ? email.split('@')[0] : email;

        // Registrasi menggunakan Firebase Auth
        User? user = await _authService.signUpWithEmailAndPassword(email, password);
        if (user != null) {
          // Navigasi ke PersonalizationScreen dengan data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalisasiScreen(
                name: name,
                firstName: firstName,
                email: email,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mendaftar. Coba lagi.")),
          );
        }
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
          'Daftar',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Apakah sudah memiliki akun?',
            style: TextStyle(color: tGreyColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text(
              'Masuk',
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
    return const Text(
      "NutriSmart",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40,
        color: tPrimaryColor,
        fontFamily: "Nunito",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFieldSignUp("Nama Lengkap", icon: Icons.account_circle_outlined, controller: _nameController),
        _entryFieldSignUp("Alamat Email", icon: Icons.email_outlined, controller: _emailController),
        _entryFieldSignUp("Kata Sandi", isPassword: true, icon: Icons.lock_outline, controller: _passwordController),
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
                    const SizedBox(height: 20),
                    _emailPasswordWidget(),
                    const SizedBox(height: 20),
                    _submitButton(),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
