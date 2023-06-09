import 'package:car_sales_app/Widgets/get_logos.dart';
import 'package:car_sales_app/bloc/cart_bloc.dart';
import 'package:car_sales_app/const/colors.dart';
import 'package:car_sales_app/const/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Column(
        children: <Widget>[
          _customCartAppBar(context),
          Expanded(
            child: StreamBuilder(
              stream: cartBloc.getStream,
              initialData: cartBloc.getList(),
              builder: (context, snapshot) {
                return buildCart(snapshot);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _customCartAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
      child: Container(
        height: 50,
        child: Row(
          children: <Widget>[
            IconButton(
                iconSize: 35,
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.close)),
            SizedBox(
              width: 20,
            ),
            Text(
              "Cart",
              style: TextStyles.appBarText,
            )
          ],
        ),
      ),
    );
  }

  Widget buildCart(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        var cart = snapshot.data;
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: GetLogos(cart[index].brandId),
              title: Text(cart[index].carName),
              subtitle: Text(cart[index].unitPrice),
              trailing: IconButton(
                  onPressed: () {
                    AlertDialog alertDialog = new AlertDialog(
                      title: Text("Removed from Cart"),
                      content: Text("Car Name : ${cart[index].carName}"),
                    );
                    showDialog(context: context, builder: (_) => alertDialog);
                    cartBloc.removeFromCart(cart[index]);
                  },
                  icon: Icon(Icons.remove_shopping_cart_outlined)),
            ),
          ),
        );
      },
    );
  }
}
