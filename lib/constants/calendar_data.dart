import '../model/calendar_model.dart';

final List<DateTime> holidayDates = [
  DateTime(2024, 11, 18),
  DateTime(2024, 11, 20),
];

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
