import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "products": products.map((product) => product.toJson()).toList(),
        "dateTime": dateTime,
      };

  static OrderItem fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    var productsData =
        List<Map<String, dynamic>>.from(snapshot['products'] ?? []);
    var products = productsData.map((data) => CartItem.fromMap(data)).toList();
    return OrderItem(
      id: snapshot['id'],
      amount: snapshot['amount'],
      products: products,
      dateTime: snapshot['dateTime'],
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    var productsData = List<Map<String, dynamic>>.from(json['products'] ?? []);
    var products = productsData.map((data) => CartItem.fromMap(data)).toList();
    return OrderItem(
      id: json['id'],
      amount: json['amount'],
      products: products,
      dateTime: json['dateTime'].toDate(),
    );
  }
}
