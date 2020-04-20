import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String userName = "";
  String email = "";
  String id = "";
  FirebaseUser user;
  DocumentSnapshot userSnap;

  User(FirebaseUser user, DocumentSnapshot userSnap) {
    this.userName = userSnap.data["username"];
    this.email = userSnap.data["email"];
    this.id = userSnap.data["uid"];
    this.user = user;
    this.userSnap = userSnap;
  }
}
