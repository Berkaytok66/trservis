import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class BrandModels {
  Map<String, dynamic> _data = {};

  Future<void> loadData() async {
    String jsonText = await rootBundle.loadString('images/modelsjson/models.json');
    _data = json.decode(jsonText);
  }

  List<String> getModelsByBrand(String brand) {
    return List<String>.from(_data[brand] ?? []);
  }

  List<String> getBrands() {
    return _data.keys.toList();
  }
}
