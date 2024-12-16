import 'package:flutter/material.dart';
import 'package:ns_apps/screens/onboarding_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key, this.title});

  final String? title;

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late final String nama;
  late final String email;
  late final int umur;
  late final double tinggiBadan;
  late final double beratBadan;
  late final String jenisKelamin;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data profil pengguna (Contoh)
    nama = 'Hasna';
    email = 'hasna@mail.com';
    umur = 20;
    tinggiBadan = 175;
    beratBadan = 70;
    jenisKelamin = 'Perempuan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Profil'),
        foregroundColor:Colors.white, backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Avatar profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/avatar.png'), // Gambar profil
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),

            // Info profil
            _buildProfileItem('Nama', nama),
            _buildProfileItem('Email', email),
            _buildProfileItem('Umur', '$umur tahun'),
            _buildProfileItem('Tinggi Badan', '$tinggiBadan cm'),
            _buildProfileItem('Berat Badan', '$beratBadan kg'),
            _buildProfileItem('Jenis Kelamin', jenisKelamin),
            const SizedBox(height: 20),

            // Tombol aksi
            _buildButton(context, 'About', Icons.info, _onAboutPressed),
            const SizedBox(height: 16),
            _buildButton(context, 'Keluar Akun', Icons.logout, _onLogoutPressed),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan informasi profil
  Widget _buildProfileItem(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol aksi
  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    Color buttonColor;
    if (text == 'About') {
      buttonColor = Colors.green; // Warna hijau untuk tombol About
    } else if (text == 'Keluar Akun') {
      buttonColor = Colors.red; // Warna merah untuk tombol Keluar Akun
    } else {
      buttonColor = Colors.green; // Warna default
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: buttonColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Implementasi logika tombol About
  void _onAboutPressed() {
    // Logika untuk navigasi atau dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text('Aplikasi Nutrismart dibuat untuk memenuhi tugas Final Project mata kuliah Teknologi Berkembang. Dikembangkan oleh Kelompok 10 Tekber.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // Implementasi logika tombol Keluar Akun
  void _onLogoutPressed() {
    // Logika untuk logout atau navigasi keluar
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar Akun'),
          content: const Text('Apakah Kamu yakin ingin keluar dari akun ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Implementasi logika logout
                Navigator.push(
                context, MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                );
                // Bisa menambahkan proses logout di sini
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
