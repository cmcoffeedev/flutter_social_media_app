import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'AuthUtil.dart';

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
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email)
                ),
                validator: (value){
                  if (value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },

              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key)
                ),

                validator: (value){
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },

              ),


              RaisedButton(
                color: Colors.purple,
                child: Text("Login", style: TextStyle(color: Colors.white),),
                onPressed: (){

                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
//                      Scaffold.of(context)
//                          .showSnackBar(SnackBar(content: Text('Processing Data')));

                    AuthUtil.signInUser(emailController.text, passwordController.text).then((AuthResult authResult){

                      print("authResult is ${authResult.user.email}");

                    });
                  }
                  else {
                    print("check errors");
                  }

                },
              )
            ],
          ),
        ),

      ) ,
    );
  }
}
