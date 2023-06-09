import 'package:car_sales_app/Widgets/get_logos.dart';
import 'package:car_sales_app/bloc/cart_bloc.dart';
import 'package:car_sales_app/const/colors.dart';
import 'package:car_sales_app/const/text_styles.dart';
import 'package:car_sales_app/data/car_api.dart';
import 'package:car_sales_app/data/car_brands_api.dart';
import 'package:car_sales_app/models/car.dart';
import 'package:car_sales_app/models/car_brands.dart';
import 'package:car_sales_app/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarCategorized extends StatefulWidget {
  int brandId;

  CarCategorized(this.brandId);

  @override
  State<StatefulWidget> createState() {
    return _CarCategorizedState(brandId);
  }
}

class _CarCategorizedState extends State {
  int brandId;
  _CarCategorizedState(this.brandId);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        body: Column(
          children: [customCategorizedAppBar, getCategorizedCars(brandId)],
        ),
      ),
    );
  }

  Widget get customCategorizedAppBar => FutureBuilder(
      future: CarBrandsApi.getBrandsData(),
      builder: (context, data) {
        if (data.hasError) {
          return Center(
            child: Text("${data.error}"),
          );
        } else if (data.hasData) {
          var items = data.data as List<CarBrands>;
          return AnimatedContainer(
            duration: Duration(milliseconds: 800),
            height: 80,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xff252525),
                        size: 35,
                      )),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    items[brandId - 1].brandName,
                    style: TextStyles.brandAppBarText,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

Widget getCategorizedCars(int brandId) {
  return Expanded(
      child: FutureBuilder(
    future: CarApi.getCarData(),
    builder: (context, data) {
      if (data.hasError) {
        return Center(
          child: Text("${data.error}"),
        );
      } else if (data.hasData) {
        var items = data.data as List<Car>;
        return ListView.separated(
          itemCount: data.data!.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
          itemBuilder: (context, index) {
            if (brandId == items[index].brandId) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(items[index].carImage),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: GetLogos(items[index].brandId),
                            ),
                            Column(
                              children: [
                                Text(
                                  items[index].carName,
                                  style: TextStyles.carNameText,
                                ),
                                Text(
                                  items[index].unitPrice,
                                  style: TextStyles.carPriceSub,
                                ),
                              ],
                            ),
                            IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  cartBloc.cartAdd(items[index]);
                                  AlertDialog alertDialog = new AlertDialog(
                                    title: Text("Added to Cart"),
                                    content: Text(
                                        "Car Name : ${items[index].carName}"),
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (_) => alertDialog);
                                },
                                icon: Icon(Icons.add_shopping_cart_outlined))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center();
            }
          },
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  ));
}
