import 'dart:async';

import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';
import 'google_auth.dart';
import 'setnote_widgets.dart';

class MyPage extends StatefulWidget {
  MyPage({this.title});
  final String title;

  @override
  State createState() => new _MyPageState(title: title);
}

class _MyPageState extends State<MyPage> {
  _MyPageState({this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(constant.app_name + " - " + title)),
      drawer: new Drawer(
        child: new MyDrawer(),
      ),
      body: new Center(
        child: new ListView(
          shrinkWrap: true,
          padding: constant.standard_margin,
          children: <Widget>[
            new Center(
              child: (googleSignIn.currentUser != null
                  ? new Text("Sei connesso come: " +
                      googleSignIn.currentUser.displayName)
                  : new Center(child: new CircularProgressIndicator())),
            ),
            new Center(
              child: new SetnoteButton(
                label: "Login",
                onPressed: () => login(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> login() async {
    await ensureLoggedIn();
    setState(() => null);
  }
}
