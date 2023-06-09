import 'dart:async';

import 'package:car_sales_app/data/cart_service.dart';
import 'package:car_sales_app/models/car.dart';

class CartBloc {
  final cartStreamController = StreamController.broadcast();

  Stream get getStream => cartStreamController.stream;

  void cartAdd(Car car) {
    CartService.cartAdd(car);
    cartStreamController.sink.add(CartService.getList());
  }

  void removeFromCart(Car car) {
    CartService.removeFromCart(car);
    cartStreamController.sink.add(CartService.getList());
  }

  List<Car> getList() {
    return CartService.getList();
  }
}

final cartBloc = CartBloc();
