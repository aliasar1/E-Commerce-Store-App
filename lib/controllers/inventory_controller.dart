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
}
