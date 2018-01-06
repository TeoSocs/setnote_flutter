import 'dart:async';

import 'package:flutter/material.dart';

import 'constants.dart' as constant;
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
    return new SetnoteBaseLayout(
      title: constant.app_name + ' - ' + title,
      child: new Align(
        alignment: Alignment.center,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            (googleSignIn.currentUser != null
                ? new Text("Sei connesso come: " +
                    googleSignIn.currentUser.displayName)
                : new CircularProgressIndicator()),
            new SetnoteButton(
              label: "Login",
              onPressed: () => login(),
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
