import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/calendar_model.dart';

final List<DateTime> holidayDates = [
  DateTime(2024, 11, 18),
  DateTime(2024, 11, 20),
  DateTime(2024, 11, 28),
];

final Map<DateTime, List<Batas>> batasMaksimal = {
  DateTime(2024, 11, 18): [
    Batas(jenis: "Lemak", batas: 65.0),
    Batas(jenis: "Gula", batas: 50.0),
    Batas(jenis: "Garam", batas: 5.0),
  ],
  DateTime(2024, 11, 20): [
    Batas(jenis: "Lemak", batas: 70.0),
    Batas(jenis: "Gula", batas: 50.0),
    Batas(jenis: "Garam", batas: 8.0),
  ],
  DateTime(2024, 11, 28): [
    Batas(jenis: "Lemak", batas: 67.0),
    Batas(jenis: "Gula", batas: 45.0),
    Batas(jenis: "Garam", batas: 7.0),
  ],
};

final Map<DateTime, List<ChartData>> chartData = {
  DateTime(2024, 11, 18): [
    ChartData(jenis: 'Lemak', konsumsi: 62, warna: const Color.fromRGBO(239, 99, 81, 1)), 
    ChartData(jenis: 'Garam', konsumsi: 5, warna: const Color.fromARGB(255, 84, 182, 87)),
    ChartData(jenis: 'Gula', konsumsi: 18, warna: const Color.fromARGB(255, 254, 185, 75)), 
  ],
  DateTime(2024, 11, 20): [
    ChartData(jenis: 'Lemak', konsumsi: 55, warna: const Color.fromRGBO(239, 99, 81, 1)), 
    ChartData(jenis: 'Garam', konsumsi: 5, warna: const Color.fromARGB(255, 84, 182, 87)), 
    ChartData(jenis: 'Gula',  konsumsi: 15, warna: const Color.fromARGB(255, 254, 185, 75)),
  ],
  DateTime(2024, 11, 28): [
    ChartData(jenis: 'Lemak', konsumsi: 65, warna: const Color.fromRGBO(239, 99, 81, 1)),
    ChartData(jenis: 'Garam', konsumsi: 5, warna: const Color.fromARGB(255, 84, 182, 87)), 
    ChartData(jenis: 'Gula', konsumsi: 20, warna: const Color.fromARGB(255, 254, 185, 75)), 
  ],
};

List<BarSeries<ChartData, String>> buildChartSeries(
    DateTime selectedDay, Batas batas) {

  List<BarSeries<ChartData, String>> seriesList = [];

  // Ambil data chart sesuai dengan jenis nutrisi
  List<ChartData> konsumsiData = chartData[selectedDay]!;
  
  ChartData konsumsi = konsumsiData.firstWhere((item) => item.jenis == batas.jenis);

  seriesList.add(
    BarSeries<ChartData, String>(
      dataSource: <ChartData>[
        ChartData(
          jenis: batas.jenis,
          konsumsi: batas.batas,
          warna: konsumsi.warna.withOpacity(0.5),
        ),
        ChartData(
          jenis: batas.jenis,
          konsumsi: konsumsi.konsumsi,
          warna: konsumsi.warna,
        ),
      ],
      xValueMapper: (ChartData data, _) => data.jenis,
      yValueMapper: (ChartData data, _) => data.konsumsi,
      name: batas.jenis,
      pointColorMapper: (ChartData data, _) => data.warna,
      dataLabelSettings: const DataLabelSettings(isVisible: true),
    ),
  );

  return seriesList;
}
