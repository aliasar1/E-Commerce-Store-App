import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../managers/firebase_manager.dart';
import '../utils/exports/controllers_exports.dart';
import '../utils/exports/models_exports.dart';
import '../utils/utils.dart';

class OrderController extends GetxController {
  final inventoryController = Get.put(InventoryController());
  final RxList<OrderItem> _orders = <OrderItem>[].obs;
  List<OrderItem> get orders => _orders.toList();

  final RxList<OrderItem> _sellerOrders = <OrderItem>[].obs;
  List<OrderItem> get sellerOrders => _sellerOrders.toList();

  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final RxList<Map<String, dynamic>> _userOrderInfo =
      <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get userOrderInfo => _userOrderInfo.toList();

  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    fetchOrdersByOwner();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
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

  Future<void> getUserData() async {
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    _user.value = userDoc.data() as Map<String, dynamic>;
  }

  Future<void> placeOrder(List<CartItem> cartItems, double totalAmount) async {
    try {
      final userId = firebaseAuth.currentUser!.uid;

      final Map<String, List<CartItem>> ordersByOwner = {};

      await getUserData();

      final bUser = User.fromMap(user);

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
            .set({
          ...orderItem.toJson(),
          'buyerInfo': bUser.toJson(),
        });
      }

      await firestore.collection('cartItems').doc(userId).delete();

      for (var cartItem in cartItems) {
        await inventoryController.decrementStockQuantity(cartItem.productId);
      }
      Utils.dismissLoadingWidget();

      Get.snackbar(
        'Success!',
        'Order placed successfully.',
      );
    } catch (error) {
      Utils.dismissLoadingWidget();
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

    _userOrderInfo.addAll(querySnapshot.docs.map((doc) {
      final orderData = doc.data();
      final buyerInfo = orderData['buyerInfo'] as Map<String, dynamic>;
      return buyerInfo;
    }).toList());

    isLoading.value = false;
  }
}
