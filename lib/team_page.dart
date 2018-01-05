import 'dart:async';

import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';
import 'google_auth.dart';

class TeamPage extends StatefulWidget {
  TeamPage({this.title});
  final String title;

  @override
  State createState() => new _TeamPageState(title: title);
}

class _TeamPageState extends State<TeamPage> {
  _TeamPageState({this.title});

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
          padding: new EdgeInsets.all(10.0),
          children: <Widget>[
            new Center(child: new CircularProgressIndicator()),
            new Center(
              child: new RaisedButton(
                child: new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Text("Login")),
                onPressed: () => login(),
              ),
            ),
            new Center(
              child: (googleSignIn.currentUser != null
                  ? new Text("Sei connesso come: " + googleSignIn.currentUser.displayName)
                  : new Text("Non sei ancora connesso")
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> login() async {
    await ensureGoogleLogin();
    setState(() => null);
  }
}