import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class YearlyModel {
  String year;
  int financial;
  final charts.Color color;

  YearlyModel(this.year, this.financial, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}