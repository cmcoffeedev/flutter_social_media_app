import 'package:firebase_auth/firebase_auth.dart';

class AuthUtil{

  static Future<AuthResult> signInUser( username,password,){

    return FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password).then((value){
      return value;
    });
  }

  static Future<AuthResult> registerUser( username,password,){

    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: username, password: password).then((value){
      return value;
    });
  }



}
