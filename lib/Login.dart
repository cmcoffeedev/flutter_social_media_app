import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AuthUtil.dart';
import 'NewsFeed.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color(0xFF8F38AA),
                    ),
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    errorStyle: TextStyle(color: Colors.purple),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF8F38AA), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF8F38AA), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value.isNotEmpty && value.contains("@")) {
                      var splitEmail = value.split("@");
                      print("split length is ${splitEmail.length}");
                      if (splitEmail.length == 2) {
                        var firstHalf = splitEmail[0];
                        var secondHalf = splitEmail[1];

                        print(
                            "first half is $firstHalf with length of ${firstHalf.length}");
                        print(
                            "second half is $secondHalf with length of ${secondHalf.length}");

                        var secondHalfSplit = secondHalf.split(".");
                        print(
                            "second half split lenght is ${secondHalfSplit.length}");
                        print("second half 1 is [${secondHalfSplit[0]}] ");

                        if (!secondHalf.contains(".") ||
                            secondHalf.length < 3 ||
                            secondHalfSplit.length != 2 ||
                            secondHalfSplit[0].isEmpty ||
                            secondHalfSplit[1].isEmpty) {
                          return "Please enter a valid email";
                        }

                        if (firstHalf.length < 3) {
                          return "Please enter a valid email";
                        }
                      } else {
                        return "Please enter a valid email";
                      }
                    }

                    if (value.isEmpty ||
                        !value.contains("@") ||
                        !value.contains(".") ||
                        value.length < 6) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Color(0xFF8F38AA),
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    errorStyle: TextStyle(color: Colors.purple),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF8F38AA), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF8F38AA), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.purple,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        AuthUtil.signInUser(
                                emailController.text, passwordController.text)
                            .then((AuthResult authResult) {
                          print("authResult is ${authResult.user.email}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewsFeed()),
                          );
                        }).catchError((error) {
                          var e = error;
                          var authError = "";
                          print("caught error ${e.code}");
                          switch (e.code) {
                            case 'ERROR_INVALID_EMAIL':
                              authError = 'Invalid Email';
                              break;
                            case 'ERROR_USER_NOT_FOUND':
                              authError = 'User Not Found';
                              break;
                            case 'ERROR_WRONG_PASSWORD':
                              authError = 'Wrong Password';
                              break;
                            case 'ERROR_EMAIL_ALREADY_IN_USE':
                              authError =
                                  "You have an account already, please sign in";
                              break;
                            default:
                              authError = 'Error';
                              break;
                          }
                          _showErrorDataDialog(context, authError);

                          print('The error is $authError');
                        });
                      } else {
                        print("check errors");
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future _showErrorDataDialog(context, String error) async {
  var matDialog = AlertDialog(
    title: new Text("Error"),
    content: new Text(error),
    actions: <Widget>[
      new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  var cupDialog = CupertinoAlertDialog(
    title: new Text("Error"),
    content: new Text(error),
    actions: <Widget>[
      new FlatButton(
        child: new Text("Ok"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  Widget dialog = matDialog;

  if (Platform.isIOS) {
    dialog = cupDialog;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}
