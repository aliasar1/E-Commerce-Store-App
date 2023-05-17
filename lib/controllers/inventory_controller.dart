import 'package:get/get.dart';

import '../managers/firebase_manager.dart';
import '../models/product_model.dart';

class InventoryController extends GetxController {
  final RxList<Product> _products = RxList<Product>([]);

  List<Product> get products => _products;

  @override
  void onInit() {
    super.onInit();
    firestore.collection('products').snapshots().listen((querySnapshot) {
      _products.value = querySnapshot.docs
          .map((doc) => Product.fromSnap(doc))
          .toList(growable: false);
    });
  }

  Future<void> decrementStockQuantity(String productId) async {
    try {
      var productDocRef = firestore.collection('products').doc(productId);
      var productDoc = await productDocRef.get();

      if (productDoc.exists) {
        var currentStockQuantity = productDoc.data()?['stockQuantity'] ?? 0;
        if (currentStockQuantity > 0) {
          await productDocRef.update({
            'stockQuantity': currentStockQuantity - 1,
          });
        } else {
          Get.snackbar('Error!', 'Stock quantity is already zero.');
        }
      } else {
        Get.snackbar('Error!', 'Product not found.');
      }
    } catch (error) {
      Get.snackbar('Error!', 'Failed to decrement stock quantity.');
    }
  }
}
