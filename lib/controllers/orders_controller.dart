import 'package:e_commerce_shopping_app/controllers/inventory_controller.dart';
import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import '../managers/firebase_manager.dart';

class OrderController extends GetxController {
  final inventoryController = Get.put(InventoryController());
  final RxList<OrderItem> _orders = <OrderItem>[].obs;

  List<OrderItem> get orders => _orders.toList();

  final RxList<OrderItem> _sellerOrders = <OrderItem>[].obs;

  List<OrderItem> get sellerOrders => _sellerOrders.toList();

  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    isLoading.value = true;
    super.onInit();
    fetchOrders();
    fetchUserOrders();
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

  Future<void> placeOrder(List<CartItem> cartItems, double totalAmount) async {
    try {
      var orderItem = OrderItem(
        id: DateTime.now().toString(),
        amount: totalAmount,
        products: cartItems,
        dateTime: DateTime.now(),
      );

      await firestore
          .collection('orders')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('user_orders')
          .doc(orderItem.id)
          .set(orderItem.toJson());

      await firestore
          .collection('cartItems')
          .doc(firebaseAuth.currentUser!.uid)
          .delete();

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

  Future<void> fetchUserOrders() async {
    var currentUserID = firebaseAuth.currentUser!.uid;
    var querySnapshot = await firestore.collection('orders').get();

    for (var doc in querySnapshot.docs) {
      var userOrdersSnapshot = await doc.reference
          .collection('user_orders')
          .where('ownerId', isEqualTo: currentUserID)
          .get();

      for (var userOrderDoc in userOrdersSnapshot.docs) {
        var orderItem = OrderItem.fromJson(userOrderDoc.data());
        _sellerOrders.add(orderItem);
      }
    }
    isLoading.value = false;
  }
}
