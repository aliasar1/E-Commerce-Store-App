import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String name;
  int quantity;
  final double price;
  final String productId;
  final String ownerId;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.productId,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "price": price,
        "productId": productId,
        "ownerId": ownerId,
      };

  static CartItem fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CartItem(
      id: snapshot['id'],
      name: snapshot['name'],
      quantity: snapshot['quantity'],
      price: snapshot['price'],
      productId: snapshot['productId'],
      ownerId: snapshot['ownerId'],
    );
  }

  static CartItem fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      productId: map['productId'],
      ownerId: map['ownerId'],
    );
  }
}
