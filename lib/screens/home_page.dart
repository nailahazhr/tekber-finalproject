import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ns_apps/screens/calendar_screen.dart';
import 'package:ns_apps/screens/profil_screen.dart';
import 'package:ns_apps/screens/articles.dart';
import 'package:ns_apps/screens/searchView_screen.dart';
import 'package:ns_apps/screens/searchDetail_screen.dart';
import 'package:ns_apps/screens/update_screen.dart'; 
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
          MaterialPageRoute(
              builder: (context) => HomePage(firstName: widget.firstName)),
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
          MaterialPageRoute(
              builder: (context) => const ProfilScreen(
                    userId: '',
                  )),
        );
        break;
      default:
        return;
    }
  }

  void tambahMakanan(String MakananId) async {
    try {
      await FirebaseFirestore.instance.collection('nutrisiPengguna').add({
        'nama': MakananId,
        'tgl_makan': DateTime.now(),
      });
      // Jika berhasil, kembali ke halaman sebelumnya dan beri feedback pengguna
      Navigator.pop(context); // Kembali ke HomePage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil ditambahkan!')),
      );
    } catch (e) {
      // Menangani error jika ada masalah saat penambahan data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan makanan: $e')),
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
          .where('tgl_makan',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(const Duration(days: 1)))
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
      },
    );
  }

  Future<Map<String, dynamic>> _fetchNutritionDetails(
      List<QueryDocumentSnapshot> docs) async {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tombol Tambah
        GestureDetector(
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
        ),
        const SizedBox(height: 10),

        // List Makanan dari Firestore
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('nutrisiPengguna')
              .orderBy('tgl_makan', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Belum ada makanan yang ditambahkan'),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final nutrisiDoc = docs[index];
                final makananId = nutrisiDoc.id;
                final makananRef = nutrisiDoc.get('id') as DocumentReference;

                return FutureBuilder<DocumentSnapshot>(
                  future: makananRef.get(),
                  builder: (context, makananSnapshot) {
                    if (makananSnapshot.connectionState == ConnectionState.waiting) {
                      return const Card(
                        child: ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text('Memuat...'),
                        ),
                      );
                    }

                    if (!makananSnapshot.hasData || !makananSnapshot.data!.exists) {
                      return const SizedBox();
                    }

                    final makananData = makananSnapshot.data!.data() as Map<String, dynamic>;
                    final namaMakanan = makananData['nama_makanan'] ?? 'Tidak ada nama';
                    final imageUrl = makananData['img'] ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) => const Center(
                                      child: Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  )
                                : const Icon(Icons.fastfood, color: Colors.grey, size: 30),
                          ),
                        ),
                        title: Text(
                          namaMakanan,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Ditambahkan: ${_formatDate(nutrisiDoc['tgl_makan'].toDate())}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateMakananScreen(
                                      makananId: makananId,
                                      makananData: makananData,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(makananId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Fungsi helper untuk format tanggal
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  // Fungsi untuk konfirmasi penghapusan
  void _confirmDelete(String makananId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus makanan ini?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirebaseFirestore.instance.collection('nutrisiPengguna').doc(makananId).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Makanan berhasil dihapus')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus makanan: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

