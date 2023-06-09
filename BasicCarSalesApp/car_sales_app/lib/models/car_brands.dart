class CarBrands {
  late int id;
  late String brandName;
  late String seoUrl;
  late String logoImage;

  CarBrands(this.id, this.brandName, this.seoUrl, this.logoImage);

  CarBrands.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    brandName = json["brandName"];
    seoUrl = json["seoUrl"];
    logoImage = json["logoImage"];
  }

  Map toJson() {
    return {
      "id": id,
      "brandName": brandName,
      "seoUrl": seoUrl,
      "logoImage": logoImage
    };
  }
}
