import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Kalender Nutrisi",
          style: TextStyle(
            color: tThirdColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // SingleChildScrollView 
        child: Column( // Bungkus Column dengan widget container
          children: [
            _buildHarianContent()
          ],
        ),
      ),
    );
  }

  Widget _buildHarianContent() {
    DateTime startOfDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    DateTime endOfDay = startOfDay.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));

    return  Column(
      children: [
        const SizedBox(height: 24),
        EasyDateTimeLine(
          initialDate: _selectedDay, 
          onDateChange: (selectedDate) {
            setState(() {
              _selectedDay = selectedDate; 
            });
          },
          activeColor: tSecondaryColor,
        ),
        const SizedBox(height: 20),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
            .collection('nutrisiPengguna')
            .where('time', isGreaterThanOrEqualTo: DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day))
            .where('time', isLessThan: DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day).add(const Duration(days: 1)).subtract(const Duration(microseconds: 1)))
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
                double carbs = nutritionData["karbohidrat"] ?? 0;
                double fat = nutritionData["lemak"] ?? 0;
                double protein = nutritionData["protein"] ?? 0;
                double calories = nutritionData["kalori"] ?? 0;
                double sugar = nutritionData["gula"] ?? 0;
                double salt = nutritionData["garam"] ?? 0;

                // Target values
                const double carbsTarget = 200;
                const double fatTarget = 59;
                const double proteinTarget = 80;
                const double caloriesTarget = 2159;
                const double sugarTarget = 50;
                const double saltTarget = 8;

                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 238, 238, 238), 
                        thickness: 1,
                      ),
                      const SizedBox(height: 8),
                      const Text('Konsumsi Nutrisi Harian',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: tThirdColor)),
                      const SizedBox(height: 20),
                      Row( // Baris pertama
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
                        ],
                      ),
                      const SizedBox(height: 20), // Jarak antar baris
                      Row( // Baris kedua
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildCircularStat(
                              currentValue: protein,
                              targetValue: proteinTarget,
                              label: 'protein'),
                          _buildCircularStat(
                              currentValue: sugar,
                              targetValue: sugarTarget,
                              label: 'gula'),
                          _buildCircularStat(
                              currentValue: salt,
                              targetValue: saltTarget,
                              label: 'garam'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        )
      ]
    );
  }

  Future<Map<String, dynamic>> _fetchNutritionDetails(List<QueryDocumentSnapshot> docs) async {
    Map<String, dynamic> aggregatedData = {
      "karbohidrat": 0,
      "lemak": 0,
      "protein": 0,
      "kalori": 0,
      "gula": 0,
      "garam": 0,
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
        aggregatedData["gula"] += detailData["gula"] ?? 0;
        aggregatedData["garam"] += detailData["garam"] ?? 0;
      }
    }

    return aggregatedData;
  }

  Widget _buildCircularStat({
  required double currentValue,
  required double targetValue,
  required String label,
}) {
  double progress = currentValue / targetValue;
  progress = progress.clamp(0.0, 1.0);

  // Tentukan warna berdasarkan progress
  Color indicatorColor;
  if (progress >= 0.75) {
    indicatorColor = const Color.fromARGB(255, 239, 99, 81); // Merah jika >= 75%
  } else if (progress >= 0.5) {
    indicatorColor = const Color.fromARGB(255, 239, 194, 81); // Kuning jika >= 50%
  } else {
    indicatorColor = const Color.fromARGB(255, 41, 150, 44); // Hijau jika < 50%
  }

    return Card(
      color: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25, // Perbesar width
        height: 150, // Perbesar height
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                    strokeWidth: 10, // Perbesar strokeWidth
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '$currentValue/$targetValue',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
