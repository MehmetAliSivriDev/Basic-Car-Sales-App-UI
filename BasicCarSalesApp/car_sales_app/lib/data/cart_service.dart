import 'package:car_sales_app/models/car.dart';

class CartService {
  static List<Car> carList = <Car>[];
  static CartService _cartSingleton = CartService._internal();

  CartService._internal();

  factory CartService() {
    return _cartSingleton;
  }

  static void cartAdd(Car car) {
    carList.add(car);
  }

  static void removeFromCart(Car car) {
    carList.remove(car);
  }

  static List<Car> getList() {
    return carList;
  }
}
