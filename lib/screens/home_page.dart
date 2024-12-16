import 'package:flutter/material.dart';
import 'package:ns_apps/data_to_cloud/pageAddMakan.dart';
import 'package:ns_apps/screens/calendar_screen.dart';
import 'package:ns_apps/screens/profil_screen.dart';
import 'package:ns_apps/screens/articles.dart';
import 'package:ns_apps/screens/searchView_screen.dart';
import '../constants/colors.dart';
import '../constants/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fungsi untuk menangani perubahan halaman pada bottom navigation bar
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalendarScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilScreen()),
        );
        break;
      default:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhiteColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: const Row(
          children: [
            Icon(Icons.front_hand, color: Colors.yellow),
            SizedBox(width: 8),
            Text(
              'Halo Hasna',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ayo lengkapi nutrisi kamu hari ini!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildNutritionStats(),
            const SizedBox(height: 20),
            _buildSectionHeader('Artikel', Icons.article),
            const SizedBox(height: 8),
            _buildArticles(context),
            const SizedBox(height: 20),
            _buildSectionHeader('Sarapan', Icons.free_breakfast),
            _buildMealSection(),
            const SizedBox(height: 20),
            _buildSectionHeader('Makan Siang', Icons.lunch_dining),
            _buildMealSection(),
            const SizedBox(height: 20),
            _buildSectionHeader('Makan Malam', Icons.bakery_dining_outlined),
            _buildMealSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: MakananSearchDelegate(),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Mau makan apa?',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('Statistik Bulan Ini',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularStat('2159', 'kcal left'),
              _buildStatCircle('0/123 g', 'carbs'),
              _buildStatCircle('0/59 g', 'fat'),
              _buildStatCircle('0/80 g', 'protein'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularStat(String value, String label) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 6,
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildStatCircle(String value, String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 3),
          ),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.brown, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
      ],
    );
  }

  Widget _buildArticles(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildArticleCard(
              context, 'Dampak Buruk GGL Berlebih', 'assets/images/burger.png'),
          _buildArticleCard(context, '4 Tips Mengonsumsi Makanan Manis',
              'assets/images/sweets.png'),
          _buildArticleCard(
              context, 'Dampak Buruk GGL Berlebih', 'assets/images/burger.png'),
          _buildArticleCard(context, '4 Tips Mengonsumsi Makanan Manis',
              'assets/images/sweets.png'),
        ],
      ),
    );
  }

  Widget _buildArticleCard(
      BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman artikel
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ArticlesPage(), // Navigasi ke ArticlesPage
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection() {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PageAddMakan()),
            );
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.add, color: Colors.green),
            ),
          ),
        );
      },
    );
  }
}
