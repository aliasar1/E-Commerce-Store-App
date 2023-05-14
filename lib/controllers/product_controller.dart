import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../managers/firebase_manager.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final RxList<Product> _products = RxList<Product>([]);

  List<Product> get products => _products;

  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productPriceController = TextEditingController();
  final productStockQuantityController = TextEditingController();
  final productCategoryController = TextEditingController();

  Rx<bool> isLoading = false.obs;
  final addFormKey = GlobalKey<FormState>();

  final Rx<File?> _pickedImage = Rx<File?>(null);
  File? get posterPhoto => _pickedImage.value;

  @override
  void onInit() {
    super.onInit();
    firestore.collection('products').snapshots().listen((querySnapshot) {
      _products.value = querySnapshot.docs
          .map((doc) => Product.fromSnap(doc))
          .toList(growable: false);
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

  Future<void> updateProduct(String id, String name, String description,
      String price, String stockQty, File? image) async {
    toggleLoading();
    String imageUrl = "";
    if (image != null) {
      imageUrl = await _uploadToStorage(image, id);
      print(imageUrl);
    }

    Product product = Product(
        id: id,
        name: name,
        description: description,
        ownerId: firebaseAuth.currentUser!.uid,
        imageUrl: imageUrl,
        price: int.parse(price),
        stockQuantity: int.parse(stockQty));

    await firestore
        .collection('products')
        .doc(id)
        .update(product.toJson())
        .whenComplete(() {
      Get.snackbar(
          'Product Updated.', 'You have successfully updated your product.');
      resetFields();
      toggleLoading();
      Get.back();
    });
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
