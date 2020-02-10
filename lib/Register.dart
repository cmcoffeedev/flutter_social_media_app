import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/AuthUtil.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
              TextFormField(
                controller: confirmPassController,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key)
                ),
                validator: (value){
                  if (value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (value != passwordController.text) {
                    return 'Please enter the same password';
                  }
                  return null;
                },

              ),

              RaisedButton(
                color: Colors.purple,
                child: Text("Register", style: TextStyle(color: Colors.white),),
                onPressed: (){

                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
//                      Scaffold.of(context)
//                          .showSnackBar(SnackBar(content: Text('Processing Data')));

                    AuthUtil.registerUser(emailController.text, passwordController.text);
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
