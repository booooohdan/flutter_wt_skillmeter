import 'package:flutter/material.dart';

class ChartData {
  ChartData({required this.x, required this.y, this.y1 = 0, this.y2 = 0, this.y3 = 0, this.y4 = 0, this.color = Colors.white});
  final String x;
  final int y;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
  final Color color;
}
