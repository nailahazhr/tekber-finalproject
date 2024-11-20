import 'package:flutter/material.dart';
import 'package:ns_apps/screens/personalisasi_screen.dart';
import '../constants/colors.dart';
import '../constants/images.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Fungsi untuk menangani perubahan halaman pada bottom navigation bar
  void _onItemTapped(BuildContext context, int index) {
    if (index == 1) {
      // Navigasi ke PersonalisasiScreen ketika ikon profil dipilih
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PersonalisasiScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Halo Hasna',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ayo lengkapi nutrisi hari ini!'),
            SizedBox(height: 20),
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildNutritionStats(),
            SizedBox(height: 20),
            Text('Artikel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildArticles(),
            SizedBox(height: 20),
            _buildMealSection('Sarapan'),
            _buildMealSection('Makan Siang'),
            _buildMealSection('Makan Malam'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'),
        ],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Makan apa?',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildNutritionStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          Text('Statistik Bulan Ini',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [Text('2159'), Text('kcal left')],
              ),
              Column(
                children: [Text('0/123 g'), Text('carbs')],
              ),
              Column(
                children: [Text('0/59 g'), Text('fat')],
              ),
              Column(
                children: [Text('0/80 g'), Text('protein')],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticles() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row (
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildArticleCard(
              'Dampak Buruk GGL Berlebih', 'assets/images/burger.png'),
          _buildArticleCard(
              '4 Tips Mengonsumsi Makanan Manis', 'assets/images/sweets.png'),
          _buildArticleCard(
              'Dampak Buruk GGL Berlebih', 'assets/images/burger.png'),
          _buildArticleCard(
              '4 Tips Mengonsumsi Makanan Manis', 'assets/images/sweets.png'),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
      color: Colors.green.shade100,
      borderRadius: BorderRadius.circular(10),
      
      ),
      width: 155,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Image.asset(imagePath, height: 90, fit: BoxFit.cover),
          ),
        ),
          SizedBox(height: 2),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildMealSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.add, color: Colors.green),
        ),
      ],
    );
  }
}
