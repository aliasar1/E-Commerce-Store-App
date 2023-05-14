import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../managers/firebase_manager.dart';
import '../models/product_model.dart';

class SearchController extends GetxController {
  final Rx<List<Product>> _searchedProducts = Rx<List<Product>>([]);

  List<Product> get searchedProducts => _searchedProducts.value;

  Future<void> searchProduct(String typedUser) async {
    if (typedUser.isEmpty) {
      _searchedProducts.value = [];
      return;
    }
    List<Product> retVal = [];
    QuerySnapshot query = await firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: typedUser.toLowerCase())
        .get();
    if (query.docs.isNotEmpty) {
      for (var elem in query.docs) {
        Product product = Product.fromSnap(elem);
        if (product.name.toLowerCase().contains(typedUser.toLowerCase())) {
          retVal.add(product);
        }
      }
    }
    _searchedProducts.value = retVal;
  }
}
