import 'cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        "products": products,
        "dateTime": dateTime,
      };

  static OrderItem fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return OrderItem(
      id: snapshot['id'],
      amount: snapshot['amount'],
      products: snapshot['products'],
      dateTime: snapshot['dateTime'],
    );
  }
}
