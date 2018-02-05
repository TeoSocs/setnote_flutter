import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'main_menu.dart';
import 'match_list.dart';
import 'match_properties.dart';
import 'team_list.dart';
import 'team_properties.dart';
import 'team_stats.dart';

// import 'package:shared_preferences/shared_preferences.dart';

/// Avvia l'applicazione.
///
/// Carica i mock delle SharedPreferences e avvia l'applicazione, associando
/// ad ogni route la pagina corrispondente.
void main() {
  // SharedPreferences.setMockInitialValues({
  //   'flutter.localTeams': '[{"ultimaModifica":"123455",' +
  //       '"key":"chiavesecondasquadra",' +
  //       '"stagione":"2018",' +
  //       '"categoria":"Serie X Femminile",' +
  //       '"nome":"Vattelapesca",' +
  //       '"coloreMaglia":"Color(0xff214d82)",' +
  //       '"allenatore":"allenatore2",' +
  //       '"assistente":"assistente2"}]'
  // });
  // SharedPreferences.setMockInitialValues({});
  runApp(new MaterialApp(
    title: constant.app_name,
    home: new MainMenu(), // becomes the route named '/'
    routes: <String, WidgetBuilder>{
      '/match': (BuildContext context) => new MatchTeamList(),
      '/team': (BuildContext context) => new TeamList(),
      '/stats': (BuildContext context) => new StatsTeamList(),
      '/history': (BuildContext context) =>
          new MatchList(),
      '/manage_team': (BuildContext context) => new TeamProperties(),
    },
  ));
}
