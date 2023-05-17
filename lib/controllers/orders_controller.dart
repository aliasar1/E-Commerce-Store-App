import 'package:get/get.dart';

import '../models/cart_item.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  final RxList<OrderItem> _orders = <OrderItem>[].obs;

  List<OrderItem> get orders {
    return _orders.toList();
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
  }
}
