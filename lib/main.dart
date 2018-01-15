import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'constants.dart' as constant;
import 'main_menu.dart';
import 'manage_team.dart';
import 'match_page.dart';
import 'mypage.dart';
import 'my_team_page.dart';


void main() {
  // SharedPreferences.setMockInitialValues({'flutter.localTeams':'[{"ultima_modifica":"123455","key":"chiavesecondasquadra","stagione":"2018","categoria":"Serie X Femminile","nome":"Vattelapesca","colore_maglia":"Color(0xff214d82)","allenatore":"allenatore2","assistente":"assistente2"}]'});
  // SharedPreferences.setMockInitialValues({});
  runApp(new MaterialApp(
    title: constant.app_name,
    home: new MainMenu(), // becomes the route named '/'
    routes: <String, WidgetBuilder>{
      '/match': (BuildContext context) =>
          new MatchPage(title: constant.match_label),
      '/team': (BuildContext context) => new MyTeamPage(),
      '/stats': (BuildContext context) =>
          new MyPage(title: constant.stats_label),
      '/history': (BuildContext context) =>
          new MyPage(title: constant.history_label),
      '/settings': (BuildContext context) =>
          new MyPage(title: constant.settings_label),
      '/formations': (BuildContext context) =>
      new MyPage(title: constant.formations_label),
      '/manage_team': (BuildContext context) =>
      new ManageTeam(),
    },
  ));
}
