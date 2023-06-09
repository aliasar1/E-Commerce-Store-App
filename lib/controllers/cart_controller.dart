import 'package:e_commerce_shopping_app/managers/firebase_manager.dart';
import 'package:get/get.dart';

import '../models/cart_item.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = RxList<CartItem>([]);

  List<CartItem> get cartItems => _cartItems.toList();

  int get cartItemsCount {
    return _cartItems.length;
  }

  Rx<bool> isLoading = false.obs;

  final RxDouble _total = 0.0.obs;
  double get total => _total.value;

  @override
  void onInit() {
    super.onInit();
    initializeCartItems();
  }

  Future<void> initializeCartItems() async {
    isLoading.value = true;

    try {
      var userDocRef =
          firestore.collection('cartItems').doc(firebaseAuth.currentUser!.uid);
      var userDoc = await userDocRef.get();

      if (userDoc.exists) {
        var cartItemsData =
            List<Map<String, dynamic>>.from(userDoc.data()?['items'] ?? []);
        var cartItems = cartItemsData
            .map((itemData) => CartItem.fromMap(itemData))
            .toList();

        _cartItems.assignAll(cartItems);
      } else {
        _cartItems.clear();
      }

      isLoading.value = false;
      totalAmount();
    } catch (error) {
      Get.snackbar('Error!', 'Failed to load cart items.');
      isLoading.value = false;
    }
  }

  void totalAmount() {
    double total = 0.0;
    for (int i = 0; i < cartItemsCount; i++) {
      total += cartItems[i].price * cartItems[i].quantity;
    }
    _total.value = total;
  }

  Future<void> addToCart(
      String productId, String name, String price, String ownerId) async {
    var newItem = CartItem(
      id: DateTime.now().toString(),
      name: name,
      quantity: 1,
      price: double.parse(price),
      productId: productId,
      ownerId: ownerId,
    );

    var userDocRef =
        firestore.collection('cartItems').doc(firebaseAuth.currentUser!.uid);
    var userDoc = await userDocRef.get();

    if (userDoc.exists) {
      var cartItems =
          List<Map<String, dynamic>>.from(userDoc.data()?['items'] ?? []);
      var existingItemIndex =
          cartItems.indexWhere((item) => item['productId'] == productId);

      if (existingItemIndex != -1) {
        cartItems[existingItemIndex]['quantity'] += 1;
      } else {
        cartItems.add(newItem.toJson());
      }

      await userDocRef.update({'items': cartItems});
    } else {
      await userDocRef.set({
        'items': [newItem.toJson()]
      });
    }

    Get.snackbar('Success!', 'Item added to cart.');
  }

  void clear() {
    _total.value = 0;
    _cartItems.clear();
  }

  Future<void> removeFromCart(String productId) async {
    var userDocRef =
        firestore.collection('cartItems').doc(firebaseAuth.currentUser!.uid);
    var userDoc = await userDocRef.get();

    if (userDoc.exists) {
      var cartItems =
          List<Map<String, dynamic>>.from(userDoc.data()?['items'] ?? []);
      var existingItemIndex =
          cartItems.indexWhere((item) => item['productId'] == productId);

      if (existingItemIndex != -1) {
        cartItems.removeAt(existingItemIndex);
        await userDocRef.update({'items': cartItems});
        Get.snackbar('Success!', 'Item removed from cart.');
      } else {
        Get.snackbar('Error!', 'Item not found in cart.');
      }
      _cartItems.assignAll(
          cartItems.map((itemData) => CartItem.fromMap(itemData)).toList());
      totalAmount();
    } else {
      Get.snackbar('Error!', 'Cart not found.');
    }
  }
}
