import 'dart:convert';

import 'package:car_sales_app/models/car.dart';
import 'package:flutter/services.dart' as rootBundle;

class CarApi {
  static Future<List<Car>> getCarData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('jsonfile/cars.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => Car.fromJson(e)).toList();
  }
}
