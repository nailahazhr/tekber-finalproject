import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/calendar_model.dart';
import '../constants/calendar_data.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _isHarianSelected = true;

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

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
      // Header
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
      body: Column(
        children: [
          const SizedBox(height: 20),
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

  // Sections
  Widget _buildSections() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _isHarianSelected = true;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isHarianSelected ? tThirdColor : Colors.grey[300],
                borderRadius: const BorderRadius.only(
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isHarianSelected ? Colors.grey[300] : tThirdColor,
                borderRadius: const BorderRadius.only(
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
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildHarianContent() {
    return Column(
      children: [
        const SizedBox(height: 24),
        EasyDateTimeLine(
          initialDate: DateTime.now(),
          onDateChange: (selectedDate) {
            setState(() {
              _selectedDay = selectedDate;
            });
          },
          activeColor: tSecondaryColor,
        ),
        const SizedBox(height: 20),
        batasMaksimal.containsKey(
                DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day))
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Colors.grey.shade100,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      "Nutrisi Harian",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tThirdColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: batasMaksimal[DateTime(
                            _selectedDay.year,
                            _selectedDay.month,
                            _selectedDay.day)]!
                        .map((batas) => _nutrisiCard(batas))
                        .toList(),
                  ),
                ],
              )
            : const Center(
                child: Text("Tidak ada informasi untuk tanggal ini."),
              ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _nutrisiCard(Batas batas) {
  return Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.98,
        height: 100, 
        child: SfCartesianChart(
          borderWidth: 0,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            // axisLine: AxisLine(width: 0),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
            isVisible: false,
          ),
          series: buildChartSeries(_selectedDay, batas), 
          tooltipBehavior: TooltipBehavior(enable: true),
        ),
      ),
    ],
  );
}

  Widget _buildBulananContent() {
    return Column(
      children: [
        const SizedBox(height: 24),
        _Calendar(),
        const SizedBox(height: 20),
        batasMaksimal.containsKey(
                DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day))
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(
                    color: Colors.grey.shade100,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Batas Maksimal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: tThirdColor,
                    ),
                  ),
                  const SizedBox(height: 12),
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
            : const Center(
                child: Text("Tidak ada informasi untuk tanggal ini."),
              ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _Calendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TableCalendar(
        rowHeight: 50,
        headerStyle: const HeaderStyle(
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
          holidayTextStyle: const TextStyle(
            color: Colors.white,
          ),
          holidayDecoration: BoxDecoration(
            color: tAccentColor2,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        holidayPredicate: (day) {
          return holidayDates.any((holiday) => isSameDay(holiday, day));
        },
        eventLoader: (day) {
          return [];
        },
      ),
    );
  }

  Widget _buildInfoCard(Batas batas) {
    return Card(
      elevation: 3,
      color: const Color.fromARGB(255, 248, 248, 248),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        // Gunakan MediaQuery untuk mengambil lebar layar
        width: MediaQuery.of(context).size.width * 0.3,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Konsumsi" "\n${batas.jenis}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tThirdColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Batas Konsumsi ${batas.jenis} Harian Anda Maksimal (gram):",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 48, 48, 48)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  batas.batas.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: tThirdColor,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: tThirdColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
