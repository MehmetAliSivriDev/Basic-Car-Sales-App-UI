import 'dart:convert';

import 'package:car_sales_app/models/car_brands.dart';
import 'package:flutter/services.dart' as rootBundle;

class CarBrandsApi {
  static Future<List<CarBrands>> getBrandsData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString("jsonfile/car_brands.json");
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => CarBrands.fromJson(e)).toList();
  }
}
