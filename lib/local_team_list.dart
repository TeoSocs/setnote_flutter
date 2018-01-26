import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Database locale delle squadre.
///
/// Database implementato come istanza statica di una classe LocalDB.
/// I dati sono memorizzati in una lista [teams] di squadre in cui ogni
/// squadra è una mappa chiave-valore.
abstract class LocalDB {
  static const String prefKey = 'localTeams';
  static List<Map<String, dynamic>> teams = new List<Map<String, dynamic>>();

  /// Controlla se la chiave è presente nella lista.
  static bool has(String key) {
    for (var team in teams) {
      if (team['key'] == key) return true;
    }
    return false;
  }

  /// Ritorna un'istanza di una squadra (oppure null) cercandola per chiave.
  static Map<String, dynamic> getByKey(String key) {
    for (var team in teams) {
      if (team['key'] == key) return team;
    }
    return null;
  }

  /// Aggiunge una squadra alla lista.
  ///
  /// Si occupa di aggiornare sia la lista [teams] che le SharedPreferences.
  static Future<Null> add(Map<String, dynamic> newTeam) async {
    teams.add(newTeam);
    store();
  }

  /// Elimina una squadra dalla lista.
  /// 
  /// Si occupa di aggiornare sia la lista [teams] che le SharedPreferences.
  static Future<Null> remove(String key) async {
    teams.remove(LocalDB.getByKey(key));
    store();
  }


  /// Salva le modifiche nelle SharedPrederences.
  static Future<Null> store() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefKey, JSON.encode(teams));
  }

  /// Legge le SharedPreferences.
  /// Stampa un su console in caso di NoSuchMethodError. Questo si verifica ogni
  /// volta che si tentano di leggere Preferences vuote.
  static Future<Null> readFromFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      teams = JSON.decode(prefs.getString(prefKey));
    } on NoSuchMethodError {
      print(
          "Errore nella lettura delle sharedPreferences, "
              + "probabilmente non sono ancora state create");
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
