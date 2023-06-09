import 'package:flutter/cupertino.dart';

class Car {
  late int id;
  late int brandId;
  late String carName;
  late String carImage;
  late String unitPrice;
  bool isLiked = false;

  Car(this.id, this.brandId, this.carName, this.carImage, this.unitPrice,
      this.isLiked);

  Car.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    brandId = json["brandId"];
    carName = json["carName"];
    carImage = json["carImage"];
    unitPrice = json["unitPrice"];
  }

  Map toJson() {
    return {
      "id": id,
      "brandId": brandId,
      "carName": carName,
      "carImage": carImage,
      "unitPrice": unitPrice
    };
  }

  set setLike(bool value) {
    this.isLiked = value;
  }
}
