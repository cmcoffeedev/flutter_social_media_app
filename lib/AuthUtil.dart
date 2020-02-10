import 'package:firebase_auth/firebase_auth.dart';

class AuthUtil{

  static Future<FirebaseUser> signInUser( username,password,){

    return FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password).then((value){
      return value.user;
    });
  }

  static Future<FirebaseUser> registerUser( username,password,){

    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: username, password: password).then((value){
      return value.user;
    });
  }



}
