import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/calendar_model.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Status untuk pilihan tampilan Harian atau Bulanan
  bool _isHarianSelected = true;

  // Konfigurasi kalender
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Tanggal yang ingin ditandai
  final _holidayDates = [
    DateTime(2024, 11, 18),
    DateTime(2024, 11, 20),
  ];

  // Data batas maksimal (contoh data)
  final Map<DateTime, List<Batas>> batasMaksimal = {
    DateTime(2024, 11, 18): [
      Batas(jenis: "Lemak", batas: 65.0),
      Batas(jenis: "Gula", batas: 50.0),
      Batas(jenis: "Garam", batas: 5.0),
    ],
    DateTime(2024, 11, 20): [
      Batas(jenis: "Lemak", batas: 70.0),
      Batas(jenis: "Gula", batas: 45.0),
      Batas(jenis: "Garam", batas: 6.0),
    ],
  };

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Kalender Nutrisi",
          style: const TextStyle(
            color: tThirdColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildSections(),
          Expanded(
            child: SingleChildScrollView(
              child: _isHarianSelected
                  ? _buildHarianContent()
                  : _buildBulananContent(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk bagian pilihan Harian atau Bulanan
  Widget _buildSections() {
    return Row(
      children: [
        SizedBox(width: 20),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _isHarianSelected = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isHarianSelected ? tThirdColor : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  "Harian",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isHarianSelected ? Colors.white : tThirdColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _isHarianSelected = false;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isHarianSelected ? Colors.grey[300] : tThirdColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  "Bulanan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isHarianSelected ? tThirdColor : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  // Widget untuk konten Harian
  Widget _buildHarianContent() {
    return Center(
      child: Text("Konten Harian"),
    );
  }

  // Widget untuk konten Bulanan
  Widget _buildBulananContent() {
    return Column(
      children: [
        SizedBox(height: 24),
        _Calendar(),
        SizedBox(height: 20),
        batasMaksimal.containsKey(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day))
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(
                    color: Colors.grey.shade100,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Batas Maksimal",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: batasMaksimal[DateTime(
                      _selectedDay.year,
                      _selectedDay.month,
                      _selectedDay.day)]!
                        .map((batas) => _buildInfoCard(batas))
                        .toList(),
                  ),
                ],
              )
            : Center(
                child: Text("Tidak ada informasi untuk tanggal ini."),
              ),
        SizedBox(height: 24),
      ],
    );
  }

  // Widget untuk kalender
  Widget _Calendar() {
    return TableCalendar(
      rowHeight: 50,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      onDaySelected: _onDaySelected,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: tThirdColor,
          borderRadius: BorderRadius.circular(10),
        ),
        todayDecoration: BoxDecoration(
          color: tAccentColor2,
          borderRadius: BorderRadius.circular(10),
        ),
        holidayDecoration: BoxDecoration(
          color: tAccentColor2,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      eventLoader: (day) {
        if (_holidayDates.any((holiday) => isSameDay(holiday, day))) {
          return [""];
        }
        return [];
      },
    );
  }

  // Widget untuk card batas maksimal
  Widget _buildInfoCard(Batas batas) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 150,
        height: 180,
        padding: EdgeInsets.only(left:(10), right:(10), top:(24), bottom:(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Konsumsi ${batas.jenis}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tThirdColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Batas Konsumsi ${batas.jenis} Harian Anda Maksimal (gram):",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  batas.batas.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: tThirdColor,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.check_circle, color: tThirdColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
