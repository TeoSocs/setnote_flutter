import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'drawer.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Setnote - "+title)
        ),
        drawer: new Drawer(
          child: new MyDrawer(),
        ),
        body: new Text(title),
    );
  }
}