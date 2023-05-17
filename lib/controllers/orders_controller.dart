import 'package:e_commerce_shopping_app/controllers/inventory_controller.dart';
import 'package:get/get.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';
import '../managers/firebase_manager.dart';

class OrderController extends GetxController {
  final inventoryController = Get.put(InventoryController());
  final RxList<OrderItem> _orders = <OrderItem>[].obs;

  List<OrderItem> get orders => _orders.toList();

  Rx<bool> isLoading = false.obs;

  @override
  void onInit() {
    isLoading.value = true;
    super.onInit();
    fetchOrders();
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
    isLoading.value = false;
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
}
