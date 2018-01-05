import 'package:flutter/material.dart';

import 'main_menu.dart';
import 'mypage.dart';

void main() {
  runApp(new MaterialApp(
    title: "Setnote",
    home: new MainMenu(), // becomes the route named '/'
    routes: <String, WidgetBuilder>{
      '/match': (BuildContext context) => new MyPage(title: 'match'),
      '/team': (BuildContext context) => new MyPage(title: 'team'),
      '/stats': (BuildContext context) => new MyPage(title: 'stats'),
      '/history': (BuildContext context) => new MyPage(title: 'history'),
      '/settings': (BuildContext context) => new MyPage(title: 'settings'),
    },
  ));
}
