import 'package:car_sales_app/const/colors.dart';
import 'package:car_sales_app/const/text_styles.dart';
import 'package:car_sales_app/data/car_brands_api.dart';
import 'package:car_sales_app/models/car_brands.dart';
import 'package:car_sales_app/screens/car_categorized%20.dart';
import 'package:car_sales_app/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrandListViewState();
  }
}

class _BrandListViewState extends State {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Column(
        children: [customBrandsAppBar, customSizedBox, getBrands],
      ),
    ));
  }

  Widget get customSizedBox => SizedBox(
        height: 10,
      );

  Widget get customBrandsAppBar => AnimatedContainer(
        duration: Duration(milliseconds: 800),
        height: 80,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Row(
            children: [
              Text(
                "Brands",
                style: TextStyles.brandAppBarText,
              ),
            ],
          ),
        ),
      );

  Widget get getBrands => Expanded(
        child: FutureBuilder(
          future: CarBrandsApi.getBrandsData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(
                child: Text("${data.error}"),
              );
            } else if (data.hasData) {
              var items = data.data as List<CarBrands>;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: data.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CarCategorized(items[index].id)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 10,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.network(items[index].logoImage),
                              ),
                              Text(
                                items[index].brandName,
                                style: TextStyles.brandTextColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
}
