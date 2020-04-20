import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'User.dart';

class CreatePostDialog extends StatefulWidget {
//  final FirebaseUser user;
  final User user;
  CreatePostDialog({Key key, this.user}) : super(key: key);

  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController postController = TextEditingController();

    return Dialog(
      child: Container(
        height: 200.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Create New Post"),
              ),
              TextField(
                controller: postController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.local_post_office,
                    color: Color(0xFF8F38AA),
                  ),
                  labelText: "Create Post",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  errorStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Post",
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
              ),
              RaisedButton(
                child: Text("Submit Post"),
                onPressed: () {
                  var postText = postController.text;
                  print("post text is $postText");
                  Firestore.instance.collection('posts').document().setData({
                    'title': postText,
                    "userEmail": widget.user.email,
                    "userId": widget.user.id,
                    "userName": widget.user.userName,
                    "date": Timestamp.now()
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
