import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ns_apps/screens/calendar_screen.dart';
import 'package:ns_apps/screens/profil_screen.dart';
import 'package:ns_apps/screens/articles.dart';
import 'package:ns_apps/screens/searchView_screen.dart';
import '../constants/colors.dart';
import '../constants/images.dart';

class HomePage extends StatefulWidget {
  final String firstName;
  
  const HomePage({Key? key, required this.firstName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fungsi untuk menangani perubahan halaman pada bottom navigation bar
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(firstName: widget.firstName)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilScreen()),
        );
        break;
      default:
        return;
    }
  }

  // Fungsi untuk menghapus data nutrisi
  Future<void> _deleteNutrition(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('nutrisiPengguna').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  // Fungsi untuk mengupdate data nutrisi
  Future<void> _updateNutrition(String docId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance.collection('nutrisiPengguna').doc(docId).update({
        ...newData,
        'time': DateTime.now(), // Menyimpan waktu update
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diupdate!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhiteColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: Row(
          children: [
            // Icon(Icons.front_hand, color: Colors.yellow),

            Text(
              'Halo ${widget.firstName}',
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
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(height: 10),
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('nutrisiPengguna')
          .where('time', isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 1)))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('No data available for today.'));
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: _fetchNutritionDetails(docs), // Fetch referenced data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final nutritionData = snapshot.data ?? {};

            // Current values
            int carbs = nutritionData["karbohidrat"] ?? 0;
            int fat = nutritionData["lemak"] ?? 0;
            int protein = nutritionData["protein"] ?? 0;
            int calories = nutritionData["kalori"] ?? 0;

            // Target values
            const int carbsTarget = 200;
            const int fatTarget = 59;
            const int proteinTarget = 80;
            const int caloriesTarget = 2159;

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
                      _buildCircularStat(
                          currentValue: calories,
                          targetValue: caloriesTarget,
                          label: 'kalori'),
                      _buildCircularStat(
                          currentValue: carbs,
                          targetValue: carbsTarget,
                          label: 'karbohidrat'),
                      _buildCircularStat(
                          currentValue: fat,
                          targetValue: fatTarget,
                          label: 'lemak'),
                      _buildCircularStat(
                          currentValue: protein,
                          targetValue: proteinTarget,
                          label: 'protein'),
                    ],
                  ),
                ],
              ),
            );
          },
        );
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>?;

            if (data == null) {
              return const SizedBox.shrink(); // Jika data null, skip
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(data['nama_makanan'] ?? 'Nama Makanan'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Karbohidrat: ${data['karbohidrat'] ?? 0} g'),
                    Text('Protein: ${data['protein'] ?? 0} g'),
                    Text('Lemak: ${data['lemak'] ?? 0} g'),
                    Text('Kalori: ${data['kalori'] ?? 0} kcal'),
                    Text('Tanggal Makan: ${data['tgl_makan'] ?? '-'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _updateNutrition(doc.id, {
                          'nama_makanan': 'Updated Makanan',
                          'tgl_makan': DateTime.now().toString(),
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteNutrition(doc.id); // Panggil fungsi hapus
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
        
      },
    );
  }

  Future<Map<String, dynamic>> _fetchNutritionDetails(List<QueryDocumentSnapshot> docs) async {
    Map<String, dynamic> aggregatedData = {
      "karbohidrat": 0,
      "lemak": 0,
      "protein": 0,
      "kalori": 0,
    };

    for (var doc in docs) {
      // Mengambil DocumentReference dari field 'id'
      DocumentReference makananRef = doc.get('id');
      DocumentSnapshot detailSnapshot = await makananRef.get();

      if (detailSnapshot.exists) {
        var detailData = detailSnapshot.data() as Map<String, dynamic>;

        // Aggregate nutritional values
        aggregatedData["karbohidrat"] += detailData["karbohidrat"] ?? 0;
        aggregatedData["lemak"] += detailData["lemak"] ?? 0;
        aggregatedData["protein"] += detailData["protein"] ?? 0;
        aggregatedData["kalori"] += detailData["kalori"] ?? 0;
      }
    }

    return aggregatedData;
  }

  Widget _buildCircularStat({
    required int currentValue,
    required int targetValue,
    required String label,
  }) {
    double progress = currentValue / targetValue;
    progress = progress.clamp(0.0, 1.0); 

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 6,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$currentValue/$targetValue',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label),
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
          showSearch(
          context: context,
          delegate: MakananSearchDelegate(),
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
