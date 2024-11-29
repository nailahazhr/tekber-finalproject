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
  // sections harian
  bool _isHarianSelected = true;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay; // update `_focusedDay` here as well
    });
  }

  // Daftar tanggal yang ingin ditandai
  final _holidayDates = [
    DateTime(2024, 11, 18),
    DateTime(2024, 11, 20),
  ];

  // Contoh data batas maksimal (ganti dengan data dari database)
  Map<DateTime, List<Batas>> batasMaksimal = {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Kalender Nutrisi",
          style: const TextStyle(
              color: tThirdColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Sections
          Row(
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
          ),
          // Section' Content
          Expanded(
            child: _isHarianSelected
                ? _buildHarianContent()
                : _buildBulananContent(),
          ),
        ],
      ),
    );
  }

  // Widget untuk konten "Harian"
  Widget _buildHarianContent() {
    // Implementasi konten harian di sini,
    // misalnya menampilkan data nutrisi harian, progress bar, dll.
    return Center(
      child: Text("Konten Harian"),
    );
  }

  // Widget untuk konten "Bulanan"
  Widget _buildBulananContent() {
    return Column(
      children: [
        SizedBox(height: 24),
        _Calendar(),
        SizedBox(height: 20),
        // Menampilkan informasi untuk tanggal yang dipilih
        if (batasMaksimal.containsKey(DateTime.utc(
            _selectedDay.year, _selectedDay.month, _selectedDay.day)))
          Column(
            children: [
              Text(
                "Batas Maksimal",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Perbaikan di sini
                child: Row(
                  children: batasMaksimal[DateTime.utc(
                          _selectedDay.year,
                          _selectedDay.month,
                          _selectedDay.day)]!
                      .map((batas) => _buildInfoCard(batas))
                      .toList(),
                ),
              ),
            ],
          ),
        // Widget lain untuk konten bulanan
        Text("Konten Bulanan lainnya"),
        SizedBox(height: 24),
      ],
    );
  }

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
        // todayDecoration: BoxDecoration(
        //   color: Colors.transparent
        // ),
        selectedDecoration: BoxDecoration(
          color: tThirdColor,
          borderRadius: BorderRadius.circular(10),
        ),
        holidayDecoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      eventLoader: (day) {
        // Menandai tanggal yang ada di _holidayDates
        if (_holidayDates.any((holiday) => isSameDay(holiday, day))) 
          return [Batas(jenis: "Holiday", batas: 0)]; // Dummy object
        else
          return [];
      },
    );
  }

  // Widget untuk menampilkan informasi batas maksimal
  Widget _buildInfoCard(Batas batas) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Konsumsi ${batas.jenis}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
                "Batas Konsumsi ${batas.jenis} Harian Anda Maksimal (gram):"),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(batas.batas.toString()),
                Icon(Icons.check),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

