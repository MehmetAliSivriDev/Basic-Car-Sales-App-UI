import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetLogos extends StatelessWidget {
  late int brandId;

  GetLogos(this.brandId);

  @override
  Widget build(BuildContext context) {
    return getLogos(brandId);
  }

  Widget getLogos(int brandId) {
    if (brandId == 1) {
      return Image.network(
          "https://pngimg.com/uploads/bmw_logo/bmw_logo_PNG19707.png");
    } else if (brandId == 2) {
      return Image.network(
          "https://www.freepnglogos.com/uploads/audi-logo-2.png");
    } else if (brandId == 3) {
      return Image.network(
          "https://www.freepnglogos.com/uploads/mercedes-logo-png/mercedes-logo-mercedes-benz-logo-png-transparent-svg-vector-bie-13.png");
    } else if (brandId == 4) {
      return Image.network(
          "https://seeklogo.com/images/R/Renault-logo-25AC313F30-seeklogo.com.png");
    } else if (brandId == 5) {
      return Image.network(
          "https://assets.stickpng.com/images/580b585b2edbce24c47b2c5e.png");
    } else if (brandId == 6) {
      return Image.network(
        "https://cdn.iconscout.com/icon/free/png-256/tofas-3441137-2874671.png",
      );
    } else {
      return Image.network(
        "",
      );
    }
  }
}
