import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ns_apps/screens/onboarding_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key, required String userId});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  // Data profil pengguna
  String nama = '';
  int umur = 0;
  double tinggiBadan = 0.0;
  double beratBadan = 0.0;
  String jenisKelamin = '';
  String aktivitas = ''; // Menambahkan atribut aktivitas
  bool isLoading = true;

  // User ID yang digunakan untuk pengambilan data
  final String userId = "agung";

  // Fungsi untuk mengambil data profil dari Firestore
  Future<void> _fetchUserData() async {
    try {
      print("Mengambil data untuk userId: $userId"); // Debug log untuk userId
      // Mengambil data dari koleksi 'personal' berdasarkan userId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('personal')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            nama = data['nama'] ?? 'Tidak ada nama';
            umur = (data['umur'] is int)
                ? data['umur']
                : int.tryParse(data['umur'].toString()) ?? 0;
            tinggiBadan = (data['tbadan'] is double)
                ? data['tbadan']
                : double.tryParse(data['tbadan'].toString()) ?? 0.0;
            beratBadan = (data['bbadan'] is double)
                ? data['bbadan']
                : double.tryParse(data['bbadan'].toString()) ?? 0.0;
            jenisKelamin = data['kelamin'] ?? 'Tidak diketahui';
            aktivitas = data['aktivitas'] ?? 'Tidak ada data';
          });
        }
      } else {
        _showSnackbar("Data tidak ditemukan untuk userId: $userId");
      }
    } catch (e) {
      _showSnackbar("Gagal mengambil data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menampilkan pesan error atau informasi
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  // Avatar profil pengguna
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          const AssetImage('assets/images/avatar.png'),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Informasi profil pengguna
                  _buildProfileItem('Nama', nama),
                  _buildProfileItem('Umur', '$umur tahun'),
                  _buildProfileItem(
                      'Tinggi Badan', '${tinggiBadan.toStringAsFixed(1)} cm'),
                  _buildProfileItem(
                      'Berat Badan', '${beratBadan.toStringAsFixed(1)} kg'),
                  _buildProfileItem('Jenis Kelamin', jenisKelamin),
                  _buildProfileItem('Aktivitas', aktivitas),
                  const SizedBox(height: 20),

                  // Tombol Aksi: About dan Keluar Akun
                  _buildButton(context, 'About', Icons.info, _onAboutPressed),
                  const SizedBox(height: 16),
                  _buildButton(
                      context, 'Keluar Akun', Icons.logout, _onLogoutPressed),
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
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol aksi
  Widget _buildButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    Color buttonColor;
    if (text == 'About') {
      buttonColor = Colors.green;
    } else if (text == 'Keluar Akun') {
      buttonColor = Colors.red;
    } else {
      buttonColor = Colors.blue;
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: buttonColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Dialog untuk tombol About
  void _onAboutPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text(
              'Aplikasi Nutrismart dibuat untuk memenuhi tugas Final Project mata kuliah Teknologi Berkembang. Dikembangkan oleh Kelompok 10 Tekber.'),
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

  // Dialog untuk tombol Keluar Akun
  void _onLogoutPressed() {
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
                Navigator.push(
                context, MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
