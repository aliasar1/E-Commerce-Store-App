import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id, name, description, ownerId, imageUrl;
  int price, stockQuantity;
  // String category;
  bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    // required this.category,
    required this.ownerId,
    required this.imageUrl,
    required this.price,
    required this.stockQuantity,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        // "category": category,
        "ownerId": ownerId,
        "imageUrl": imageUrl,
        "price": price,
        "stockQuantity": stockQuantity,
        "isAvailable": isAvailable,
      };

  static Product fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Product(
      id: snapshot['id'],
      name: snapshot['name'],
      description: snapshot['description'],
      // category: snapshot['category'],
      ownerId: snapshot['ownerId'],
      imageUrl: snapshot['imageUrl'],
      price: snapshot['price'],
      stockQuantity: snapshot['stockQuantity'],
      isAvailable: snapshot['isAvailable'],
    );
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      // category: map['category'],
      ownerId: map['ownerId'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      stockQuantity: map['stockQuantity'],
      isAvailable: map['isAvailable'],
    );
  }
}
