import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name, email, uid, profilePhoto, phone, address;

  User({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilePhoto,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "phone": phone,
        "address": address,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot["email"],
      name: snapshot["name"],
      uid: snapshot["uid"],
      profilePhoto: snapshot["profilePhoto"],
      phone: snapshot["phone"],
      address: snapshot["address"],
    );
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      email: map["email"],
      name: map["name"],
      uid: map["uid"],
      profilePhoto: map["profilePhoto"],
      phone: map["phone"],
      address: map["address"],
    );
  }
}
