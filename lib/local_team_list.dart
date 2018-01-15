import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class LocalDB {
  static const String prefKey = 'localTeams';
  static List<Map<String, dynamic>> teams = new List<Map<String, dynamic>>();

  static bool has(String key) {
    for (var team in teams) {
      if (team['key'] == key) return true;
    }
    return false;
  }

  static Map<String, dynamic> getByKey(String key) {
    for (var team in teams) {
      if (team['key'] == key) return team;
    }
    return null;
  }

  static Future<Null> add(Map<String, dynamic> newTeam) async {
    teams.add(newTeam);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefKey, JSON.encode(teams));
  }

  static Future<Null> readFromFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      teams = JSON.decode(prefs.getString(prefKey));
    } on NoSuchMethodError{
      print(
          "Errore nella lettura delle sharedPreferences, probabilmente non sono ancora state create");
    }
  }
}

// class TeamInstance {
//   String nome = '';
//   String allenatore = '';
//   String assistente = '';
//   String categoria = '';
//   String stagione = '';
//   String coloreMaglia = '';
//   String key = '';
//   String ultimaModifica;
//   List<PlayerInstance> giocatori;
//
//   Future<Null> aggiornaGiocatori() async {
//     return null;
//   }
// }
//
// class PlayerInstance {
//   String key = '';
//   String altezza = '';
//   String capitano = '';
//   String cognome = '';
//   String mancino = '';
//   String nascita = '';
//   String nazionalita = '';
//   String nome = '';
//   String peso = '';
//   String ruolo = '';
// }
//
// class PlayerData {
//   List<FundamentalData> battute;
//   List<FundamentalData> ricezioni;
//   List<FundamentalData> attacchi;
// }
//
// class FundamentalData {
//   int doppiopiu;
//   int piu;
//   int meno;
//   int doppiomeno;
// }
