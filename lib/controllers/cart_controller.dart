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

  @override
  void onInit() async {
    isLoading.value = true;
    await initializeCartItems();
    super.onInit();
  }

  Future<void> initializeCartItems() async {
    var userDocRef =
        firestore.collection('cartItems').doc(firebaseAuth.currentUser!.uid);
    var userDoc = await userDocRef.get();

    if (userDoc.exists) {
      var cartItemsData =
          List<Map<String, dynamic>>.from(userDoc.data()?['items'] ?? []);
      var cartItems =
          cartItemsData.map((itemData) => CartItem.fromMap(itemData)).toList();
      _cartItems.addAll(cartItems);
    }
    isLoading.value = false;
  }

  double get totalAmount {
    var total = 0.0;
    for (int i = 0; i < cartItemsCount; i++) {
      total = total + (cartItems[i].price * cartItems[i].quantity);
    }
    return total;
  }

  Future<void> addToCart(String productId, String name, String price) async {
    var newItem = CartItem(
      id: DateTime.now().toString(),
      name: name,
      quantity: 1,
      price: double.parse(price),
      productId: productId,
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
  }

  // void removeSingleItem(String productId) {
  //   if (!_cartItems.containsKey(productId)) {
  //     return;
  //   }
  //   if (_cartItems[productId]!.quantity > 1) {
  //     _cartItems.update(
  //         productId,
  //         (existingCartItem) => CartItem(
  //               id: existingCartItem.id,
  //               name: existingCartItem.name,
  //               price: existingCartItem.price,
  //               quantity: existingCartItem.quantity - 1,
  //             ));
  //   } else {
  //     _cartItems.remove(productId);
  //   }
  // }

  void clear() {
    _cartItems.clear();
  }
}
