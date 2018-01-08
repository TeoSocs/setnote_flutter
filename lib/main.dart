import 'package:flutter/material.dart';

import 'add_team.dart';
import 'constants.dart' as constant;
import 'main_menu.dart';
import 'match_page.dart';
import 'mypage.dart';
import 'team_page.dart';


void main() {
  runApp(new MaterialApp(
    title: constant.app_name,
    home: new MainMenu(), // becomes the route named '/'
    routes: <String, WidgetBuilder>{
      '/match': (BuildContext context) =>
          new MatchPage(title: constant.match_label),
      '/team': (BuildContext context) => new TeamPage(title: constant.team_label),
      '/stats': (BuildContext context) =>
          new MyPage(title: constant.stats_label),
      '/history': (BuildContext context) =>
          new MyPage(title: constant.history_label),
      '/settings': (BuildContext context) =>
          new MyPage(title: constant.settings_label),
      '/formations': (BuildContext context) =>
      new MyPage(title: constant.formations_label),
      '/add_team': (BuildContext context) =>
      new AddTeam(title: constant.add_team_label),
    },
  ));
}
