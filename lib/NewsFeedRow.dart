import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_button/flutter_reactive_button.dart';

class NewsFeedRow extends StatefulWidget {
  final String userImg;
  final DocumentSnapshot document;
  final FirebaseUser user;

  const NewsFeedRow({Key key, this.userImg, this.document, this.user})
      : super(key: key);

  @override
  _NewsFeedRowState createState() => _NewsFeedRowState();
}

class _NewsFeedRowState extends State<NewsFeedRow> {
  bool liked = false;
  String facebook;

  List<ReactiveIconDefinition> _facebook = <ReactiveIconDefinition>[
    ReactiveIconDefinition(
      assetIcon: 'assets/images/like.gif',
      code: 'like',
    ),
    ReactiveIconDefinition(
      assetIcon: 'assets/images/haha.gif',
      code: 'haha',
    ),
    ReactiveIconDefinition(
      assetIcon: 'assets/images/love.gif',
      code: 'love',
    ),
    ReactiveIconDefinition(
      assetIcon: 'assets/images/sad.gif',
      code: 'sad',
    ),
    ReactiveIconDefinition(
      assetIcon: 'assets/images/wow.gif',
      code: 'wow',
    ),
    ReactiveIconDefinition(
      assetIcon: 'assets/images/angry.gif',
      code: 'angry',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfUserLikedPost();
  }

  checkIfUserLikedPost() async {
    Firestore.instance
        .collection("postReactions")
        .document(widget.document.documentID + "_" + widget.user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          liked = true;
          facebook = ds["reactionType"];
        });
      }
    });
  }

  checkPost() {
    Firestore.instance
        .collection("postReactions")
        .document(widget.document.documentID + "_" + widget.user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
      if (ds.exists) {
        updateLikePost();
      } else {
        //like the post
        likePost();
      }
    });
  }

  unlikePost() {
    Firestore.instance
        .collection("postReactions")
        .document(widget.document.documentID + "_" + widget.user.uid)
        .delete()
        .then((value) {
      setState(() {
        liked = false;
      });
    });
  }

  likePost() {
    Firestore.instance
        .collection('postReactions')
        .document(widget.document.documentID + "_" + widget.user.uid)
        .setData({
      'reactionType': facebook,
      'postId': widget.document.documentID,
      'userId': widget.user.uid
    }).then((value) {
      setState(() {
        liked = true;
      });
    });
  }

  updateLikePost() {
    Firestore.instance
        .collection('postReactions')
        .document(widget.document.documentID + "_" + widget.user.uid)
        .updateData({
      'reactionType': facebook,
    }).then((value) {
      setState(() {
        liked = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var userEmail = widget.document['userEmail'];
    var userName = widget.document['userName'];
    if (userEmail == null) {
      userEmail = "no user email";
    }
    if (userName == null) {
      userName = "no user name";
    }

    return Card(
      elevation: 2.0,
      child: new ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade300,
          backgroundImage: NetworkImage(widget.userImg),
        ),
        title: new Text(widget.document['title']),
        subtitle: new Text(userName),
//        trailing: RaisedButton(
//          child: Text(liked ? "Liked" : "Like"),
//          onPressed: likePost,
//        ),
        trailing: ReactiveButton(
          child: Container(
            decoration: BoxDecoration(
//              border: Border.all(
//                color: Colors.black,
//                width: 1.0,
//              ),
              color: Colors.white,
            ),
            width: 80.0,
            height: 40.0,
            child: Center(
              child: !liked
                  ? Text('Like')
                  : Image.asset(
                      'assets/images/$facebook.png',
                      width: 32.0,
                      height: 32.0,
                    ),
            ),
          ),
          icons: _facebook, //_flags,
          onTap: () {
            print('TAP');
            unlikePost();
          },
          onSelected: (ReactiveIconDefinition button) {
            setState(() {
              facebook = button.code;
              checkPost();
            });
          },
          iconWidth: 32.0,
        ),
      ),
    );
  }
}
