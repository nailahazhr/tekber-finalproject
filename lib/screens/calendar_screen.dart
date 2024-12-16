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
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
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
          _buildHarianContent()
        ],
      ),
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
                      "Konsumsi Nutrisi Harian",
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
}
