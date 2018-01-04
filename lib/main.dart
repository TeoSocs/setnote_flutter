import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'drawer.dart';
import 'main_menu.dart';

final googleSignIn = new GoogleSignIn();

void main() {
  runApp(new MaterialApp(
    title: "Setnote",
    home: new MainMenu(), // becomes the route named '/'
    routes: <String, WidgetBuilder> {
      '/match': (BuildContext context) => new MyPage(title: 'match'),
      '/team': (BuildContext context) => new MyPage(title: 'team'),
      '/stats': (BuildContext context) => new MyPage(title: 'stats'),
      '/history': (BuildContext context) => new MyPage(title: 'history'),
      '/settings': (BuildContext context) => new MyPage(title: 'settings'),
    },
  ));
}


class MyPage extends StatelessWidget {
  MyPage({this.title});

  final String title;

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null)
      user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Setnote - " + title)
        ),
        drawer: new Drawer(
          child: new MyDrawer(),
        ),
        body: new Center(
          child: new CircularProgressIndicator(),
        )
    );
  }
}