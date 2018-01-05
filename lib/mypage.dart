import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'drawer.dart';

final googleSignIn = new GoogleSignIn();

class MyPage extends StatelessWidget {
  MyPage({this.title});

  final String title;

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null) user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Setnote - " + title)),
        drawer: new Drawer(
          child: new MyDrawer(),
        ),
        body: new Center(
          child: new CircularProgressIndicator(),
        ));
  }
}
