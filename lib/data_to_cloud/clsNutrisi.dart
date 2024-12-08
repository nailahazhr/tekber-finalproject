// To parse this JSON data, do
//
//     final clsNutrisi = clsNutrisiFromJson(jsonString);

import 'dart:convert';

ClsNutrisi clsNutrisiFromJson(String str) =>
    ClsNutrisi.fromJson(json.decode(str));

String clsNutrisiToJson(ClsNutrisi data) => json.encode(data.toJson());

class ClsNutrisi {
  String nama;
  String kategori;
  DateTime tglDibuat;

  ClsNutrisi({
    required this.nama,
    required this.kategori,
    required this.tglDibuat,
  });

  factory ClsNutrisi.fromJson(Map<String, dynamic> json) => ClsNutrisi(
        nama: json["nama"],
        kategori: json["kategori"],
        tglDibuat: DateTime.parse(json["tglDibuat"]),
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "kategori": kategori,
        "tglDibuat": tglDibuat.toIso8601String(),
      };
}
