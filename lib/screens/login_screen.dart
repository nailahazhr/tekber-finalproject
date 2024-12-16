import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ns_apps/screens/home_page.dart';
import 'package:ns_apps/screens/signup_screen.dart';
import '../constants/colors.dart';
import '../constants/images.dart';
import 'package:ns_apps/provider/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.title});

  final String? title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Widget _entryFieldLogin(String title,
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
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email dan Kata Sandi harus diisi")),
          );
          return;
        }

        User? user = await _authService.signInWithEmailAndPassword(email, password);
        if (user != null) {
          // Ekstrak nama awal dari email
          String firstName = email.contains('@') ? email.split('@')[0] : email;

          // Navigasi ke HomePage dengan nama awal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(firstName: firstName),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login gagal. Periksa kembali email dan kata sandi.")),
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
          'Masuk',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFieldLogin("Alamat Email",
            icon: Icons.account_circle_outlined, controller: _emailController),
        _entryFieldLogin("Kata Sandi",
            isPassword: true, icon: Icons.lock_outline, controller: _passwordController),
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
                    const Text(
                      "NutriSmart",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        color: tPrimaryColor,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _emailPasswordWidget(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: const Text(
                        'Lupa Sandi?',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: tSecondaryColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _submitButton(),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Belum memiliki akun?',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: tGreyColor),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpScreen()));
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
                    ),
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
