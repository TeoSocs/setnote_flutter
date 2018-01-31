import 'dart:async';

import 'package:flutter/material.dart';

import 'google_auth.dart';
import 'setnote_widgets.dart';

/// Pagina mock.
///
/// Generica pagina segnaposto.
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
      title: title,
      child: new Align(
        alignment: Alignment.center,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            (googleSignIn.currentUser != null
                ? new Text("Sei connesso come: " +
                    googleSignIn.currentUser.displayName)
                : new CircularProgressIndicator()),
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
