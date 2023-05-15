import 'dart:io';

import 'package:e_commerce_shopping_app/views/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../managers/firebase_manager.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final RxList<Product> _products = RxList<Product>([]);

  List<Product> get products => _products;

  final RxList<Product> _myProducts = RxList<Product>([]);

  List<Product> get myProducts => _myProducts;

  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockQuantityController = TextEditingController();
  final productCategoryController = TextEditingController();

  Rx<bool> isLoading = false.obs;
  final addFormKey = GlobalKey<FormState>();

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get posterPhoto => _pickedImage.value;

  final Rx<String> _productNameRx = "".obs;
  final Rx<String> _productDescriptionRx = "".obs;

  String get productName => _productNameRx.value;
  String get productDescription => _productDescriptionRx.value;

  final Rx<Map<String, dynamic>> _product = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get product => _product.value;

  @override
  void onInit() {
    super.onInit();
    firestore.collection('products').snapshots().listen((querySnapshot) {
      final products = querySnapshot.docs
          .map((doc) => Product.fromSnap(doc))
          .toList(growable: false);

      final currentUserID = firebaseAuth.currentUser?.uid;

      _products.value = products;

      if (currentUserID != null) {
        _myProducts.value = products
            .where((product) => product.ownerId == currentUserID)
            .toList(growable: false);
      }
    });
  }

  void toggleLoading() {
    isLoading.value = !isLoading.value;
  }

  Future<String> _uploadToStorage(File image, String id) async {
    Reference ref = firebaseStorage.ref().child('products').child(id);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getUniqueId() async {
    var allDocs = await firestore.collection('products').get();
    int len = allDocs.docs.length;
    return len.toString();
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Product Picture Added!',
          'You have successfully added your product picture!');
    }
    _pickedImage.value = File(pickedImage!.path);
    update();
  }

  Future<void> addProduct(
      String name, String description, String price, String stockQty) async {
    if (addFormKey.currentState!.validate()) {
      addFormKey.currentState!.save();
      toggleLoading();
      String id = await getUniqueId();
      String imageUrl = await _uploadToStorage(_pickedImage.value!, id);
      name = name.toLowerCase();
      Product product = Product(
        id: id,
        name: name,
        description: description,
        price: int.parse(price),
        imageUrl: imageUrl,
        stockQuantity: int.parse(stockQty),
        isAvailable: true,
        ownerId: firebaseAuth.currentUser!.uid,
      );
      await firestore.collection('products').doc(id).set(product.toJson());
      toggleLoading();
      Get.back();
      Get.snackbar(
        'Success!',
        'Product added successfully.',
      );
      resetFields();
    }
  }

  Future<String> _updateToStorage(File newImage, String id) async {
    Reference ref = firebaseStorage.ref().child('products').child(id);

    await ref.delete();

    UploadTask uploadTask = ref.putFile(newImage);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getImageFromStorage(String id) async {
    Reference ref = firebaseStorage.ref().child('products').child(id);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateProduct(
    String id,
    String name,
    String description,
    String price,
    String stockQty,
    String oldImageUrl,
    File? image,
    ProductController controller,
  ) async {
    toggleLoading();
    String imageUrl = "";
    if (image != null) {
      imageUrl = await _updateToStorage(image, id);
    } else {
      imageUrl = oldImageUrl;
    }

    Product product = Product(
      id: id,
      name: name,
      description: description,
      ownerId: firebaseAuth.currentUser!.uid,
      imageUrl: imageUrl,
      price: int.parse(price),
      stockQuantity: int.parse(stockQty),
    );

    await firestore
        .collection('products')
        .doc(id)
        .update(product.toJson())
        .whenComplete(() {
      _productNameRx.value = product.name;
      _productDescriptionRx.value = product.description;

      toggleLoading();
      Get.offAll(
          ProductOverviewScreen(product: product, controller: controller));
      Get.snackbar(
        'Product Updated.',
        'You have successfully updated your product.',
      );
      resetFields();
    });
  }

  void getProductData(String id) async {
    DocumentSnapshot userDoc =
        await firestore.collection('products').doc(id).get();
    _product.value = userDoc.data()! as dynamic;
    update();
  }

  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
    await firebaseStorage.ref().child('products').child(productId).delete();
  }

  void resetFields() {
    productCategoryController.clear();
    productPriceController.clear();
    productNameController.clear();
    productDescriptionController.clear();
    productStockQuantityController.clear();
    _pickedImage.value = null;
  }
}
