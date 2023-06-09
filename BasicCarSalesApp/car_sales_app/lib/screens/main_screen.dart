import 'package:car_sales_app/Widgets/get_logos.dart';
import 'package:car_sales_app/bloc/cart_bloc.dart';
import 'package:car_sales_app/const/text_styles.dart';
import 'package:car_sales_app/data/car_api.dart';
import 'package:car_sales_app/data/car_brands_api.dart';
import 'package:car_sales_app/models/car_brands.dart';
import 'package:car_sales_app/screens/brand_list_view.dart';
import 'package:car_sales_app/screens/cart_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../models/car.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State {
  List<int> topSalesIndex = <int>[13, 9, 0, 7, 11];

  late ScrollController scrollController;
  bool isHeaderClose = false;
  bool isTopSalesClose = false;
  bool isTopSalesRowClose = false;
  double lastOffset = 0;

  int _selectedIndex = 0;

  final key = GlobalKey<_MainScreen>();

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        isHeaderClose = false;
        isTopSalesClose = false;
        isTopSalesRowClose = false;
      } else if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        isHeaderClose = true;
        isTopSalesClose = true;
        isTopSalesRowClose = true;
      }
      isHeaderClose = scrollController.offset > lastOffset ? true : false;
      isTopSalesClose = scrollController.offset > lastOffset ? true : false;
      isTopSalesRowClose = scrollController.offset > lastOffset ? true : false;
      setState(() {
        lastOffset = scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(Object context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: customNavigationBar,
            backgroundColor: CustomColors.backgroundColor,
            floatingActionButton: customFabButton,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: IndexedStack(index: _selectedIndex, children: [
              Column(
                children: [
                  customAppBar,
                  mainSizedBox,
                  topSalesRow,
                  mainSizedBox,
                  topSalesCars,
                  mainSizedBox,
                  getAllCars,
                ],
              ),
              BrandListView(),
            ])));
  }

  Widget get mainSizedBox => const SizedBox(
        height: 20,
      );

  Widget get customFabButton => FloatingActionButton(
        backgroundColor: Color(0xffAD241B),
        child: Icon(
          Icons.shopping_basket_rounded,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
        },
      );

  Widget get customAppBar => AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        height: isHeaderClose ? 0 : 50,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Cars",
              style: TextStyles.appBarText,
            ),
          ]),
        ),
      );

  Widget get topSalesRow => AnimatedContainer(
        duration: Duration(milliseconds: 800),
        height: isTopSalesClose ? 0 : 22,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("TOP SALES", style: TextStyles.topSalesTextStyle),
            ],
          ),
        ),
      );

  Widget get topSalesCars => AnimatedContainer(
        duration: Duration(milliseconds: 800),
        height: isTopSalesClose ? 0 : 190,
        child: FutureBuilder(
          future: CarApi.getCarData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as List<Car>;
              return ListView.separated(
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 12,
                    );
                  },
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  items[topSalesIndex[index]].carImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: GetLogos(
                                        items[topSalesIndex[index]].brandId)),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      items[topSalesIndex[index]].carName,
                                      style: TextStyles.carNameText,
                                    ),
                                    Text(
                                      items[topSalesIndex[index]].unitPrice,
                                      style: TextStyles.carPriceSub,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                    iconSize: 30,
                                    onPressed: () {
                                      cartBloc
                                          .cartAdd(items[topSalesIndex[index]]);
                                      AlertDialog alertDialog = new AlertDialog(
                                        title: Text("Added to Cart"),
                                        content: Text(
                                            "Car Name : ${items[topSalesIndex[index]].carName}"),
                                      );
                                      showDialog(
                                          context: context,
                                          builder: (_) => alertDialog);
                                    },
                                    icon:
                                        Icon(Icons.add_shopping_cart_outlined))
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );

  Widget get getAllCars => Expanded(
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
              controller: scrollController,
              itemCount: data.data!.length,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
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
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ));

  Widget get customNavigationBar => BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Color(0xff252525),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
              backgroundColor: CupertinoColors.activeBlue),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_rounded),
              label: "",
              backgroundColor: CupertinoColors.activeBlue),
        ],
        selectedItemColor: CupertinoColors.white,
        currentIndex: _selectedIndex,
        onTap: selectedTab,
      );

  void selectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
