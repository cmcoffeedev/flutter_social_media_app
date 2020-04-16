import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/CreatePostDialog.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  Stream<QuerySnapshot> stream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    stream = Firestore.instance.collection('posts').snapshots();
    getCurrentUser();
  }

  Future getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print("logged in user is ${loggedInUser.email}");

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Feed"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Create Post"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CreatePostDialog(user: loggedInUser);
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
                        var userEmail = document['userEmail'];
                        if (userEmail == null) {
                          userEmail = "no user email";
                        }
                        return new ListTile(
                          title: new Text(document['title']),
                          subtitle: new Text(userEmail),
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
