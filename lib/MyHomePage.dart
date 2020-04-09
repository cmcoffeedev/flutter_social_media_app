import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/Register.dart';

import 'Login.dart';
import 'NewsFeed.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print("logged in user is ${loggedInUser.email}");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsFeed()),
        );
//        Firestore.instance
//            .collection('users')
//            .document(loggedInUser.uid)
//            .get()
//            .then((DocumentSnapshot ds) {
//          setState(() {
//            var fname = ds.data["fname"];
//            var lname = ds.data["lname"];
//            var phone = ds.data["phone"];
//            var email = ds.data["email"];
//
//          });
//          // use ds as a snapshot
//        });
      } else {
        print("user is null");
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Social Media App"),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Color(0xFF2699FB),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Color(0xFF2699FB),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
//      body: StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance.collection('books').snapshots(),
//        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (snapshot.hasError)
//            return new Text('Error: ${snapshot.error}');
//          switch (snapshot.connectionState) {
//            case ConnectionState.waiting: return new Text('Loading...');
//            default:
//              return new ListView(
//                children: snapshot.data.documents.map((DocumentSnapshot document) {
//                  return new ListTile(
//                    title: new Text(document['title']),
//                    subtitle: new Text(document['author']),
//                  );
//                }).toList(),
//              );
//          }
//        },
//      ),
    );
  }
}
