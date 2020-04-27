import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/AuthUtil.dart';
import 'package:social_media_app/CreatePostDialog.dart';
import 'package:social_media_app/NewsFeedRowArray.dart';

import 'MyHomePage.dart';
import 'NewsFeedRow.dart';
import 'User.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  Stream<QuerySnapshot> stream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  User user;
  String userImg =
      "https://img.icons8.com/pastel-glyph/64/000000/person-male.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    stream = Firestore.instance.collection('posts').snapshots();

    getUserInfo();
  }

  getUserInfo() async {
    loggedInUser = await AuthUtil.getCurrentUser();
    DocumentSnapshot userSnap =
        await AuthUtil.getCurrentUserFromFS(loggedInUser);
    if (userSnap != null) {
      print("userSnap is not null ${userSnap["email"]}");
      setState(() {
        user = User(loggedInUser, userSnap);
      });
    } else {
      print("userSnap is not null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("News Feed"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthUtil.signOutCurrentUser().then((val) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            color: Colors.purple,
            child: Text(
              "Create Post",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CreatePostDialog(user: user);
                  });
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return Expanded(
                    child: new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return NewsFeedRowArray(
                          userImg: userImg,
                          document: document,
                          user: loggedInUser,
                        );
                      }).toList(),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
