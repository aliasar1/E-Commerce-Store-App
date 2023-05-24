import 'package:e_commerce_shopping_app/controllers/inventory_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';
import '../models/order_model.dart';
import '../managers/firebase_manager.dart';
// import '../models/user_model.dart';

class OrderController extends GetxController {
  final inventoryController = Get.put(InventoryController());
  final RxList<OrderItem> _orders = <OrderItem>[].obs;
  List<OrderItem> get orders => _orders.toList();

  final RxList<OrderItem> _sellerOrders = <OrderItem>[].obs;
  List<OrderItem> get sellerOrders => _sellerOrders.toList();

  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    isLoading.value = true;
    super.onInit();
    fetchOrders();
    fetchOrdersByOwner();
    isLoading.value = false;
  }

  Future<void> fetchOrders() async {
    try {
      final querySnapshot = await firestore
          .collection('orders')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('user_orders')
          .orderBy('dateTime', descending: true)
          .get();

      _orders.value = querySnapshot.docs
          .map((doc) => OrderItem.fromJson(doc.data()))
          .toList();
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
      );
    }
  }

  void getUserData() async {
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    _user.value = userDoc.data()! as dynamic;
  }

  Future<void> placeOrder(List<CartItem> cartItems, double totalAmount) async {
    try {
      final userId = firebaseAuth.currentUser!.uid;

      final Map<String, List<CartItem>> ordersByOwner = {};

      var orderItem = OrderItem(
        id: DateTime.now().toString(),
        amount: totalAmount,
        products: cartItems,
        dateTime: DateTime.now(),
      );

      await firestore
          .collection('orders')
          .doc(userId)
          .collection('user_orders')
          .doc(orderItem.id)
          .set(orderItem.toJson());

      for (var cartItem in cartItems) {
        final ownerId = cartItem.ownerId;

        if (ordersByOwner.containsKey(ownerId)) {
          ordersByOwner[ownerId]!.add(cartItem);
        } else {
          ordersByOwner[ownerId] = [cartItem];
        }
      }

      for (var ownerId in ordersByOwner.keys) {
        final orderItems = ordersByOwner[ownerId]!;
        final orderItem = OrderItem(
          id: DateTime.now().toString(),
          amount: totalAmount,
          products: orderItems,
          dateTime: DateTime.now(),
        );

        await firestore
            .collection('seller_orders')
            .doc(ownerId)
            .collection('user_orders')
            .doc(orderItem.id)
            .set(
              orderItem.toJson(),
            );

        // getUserData();

        // await firestore
        //     .collection('seller_orders')
        //     .doc(ownerId)
        //     .collection('user_orders')
        //     .doc(orderItem.id)
        //     .set({
        //   ...orderItem.toJson(),
        //   'buyerInfo': User.fromMap(user),
        // });
      }

      await firestore.collection('cartItems').doc(userId).delete();

      for (var cartItem in cartItems) {
        await inventoryController.decrementStockQuantity(cartItem.productId);
      }

      Get.snackbar(
        'Success!',
        'Order placed successfully.',
      );
    } catch (error) {
      Get.snackbar(
        'Failure!',
        error.toString(),
      );
    }
  }

  Future<void> fetchOrdersByOwner() async {
    final userId = firebaseAuth.currentUser!.uid;

    final querySnapshot = await firestore
        .collection('seller_orders')
        .doc(userId)
        .collection('user_orders')
        .orderBy('dateTime', descending: true)
        .get();

    _sellerOrders.value = querySnapshot.docs
        .map((doc) => OrderItem.fromJson(doc.data()))
        .toList();
  }
}
