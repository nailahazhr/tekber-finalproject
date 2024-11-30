import 'package:flutter/material.dart';

class Batas {
  final String jenis;
  final double batas;

  Batas({required this.jenis, required this.batas});
}

class ChartData {
  final String jenis;  
  final double konsumsi;  
  final Color warna; 

  ChartData({
    required this.jenis, 
    required this.konsumsi, 
    required this.warna,
  });
}
