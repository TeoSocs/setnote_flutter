import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'constants.dart' as constant;
import 'drawer.dart';

class MyPage extends StatelessWidget {
  MyPage({this.title});

  final String title;

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = constant.googleSignIn.currentUser;
    if (user == null) user = await constant.googleSignIn.signInSilently();
    if (user == null) {
      await constant.googleSignIn.signIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(constant.app_name + " - " + title)),
        drawer: new Drawer(
          child: new MyDrawer(),
        ),
        body: new Center(
          child: new CircularProgressIndicator(),
        ));
  }
}
