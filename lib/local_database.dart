import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Database locale delle squadre.
///
/// Database implementato come istanza statica di una classe LocalDB.
/// I dati sono memorizzati in una lista [teams] di squadre in cui ogni
/// squadra è una mappa chiave-valore.
abstract class LocalDB {
  static const String prefTeamsKey = 'localTeams';
  static const String prefPlayersKey = 'localPlayers';

  /// Elenco delle squadre.
  ///
  /// Template di squadra inserita:
  /// {
  ///   String key;
  ///   String nome;
  ///   String allenatore;
  ///   String assistente;
  ///   String categoria;
  ///   String stagione;
  ///   String coloreMaglia;
  ///   String ultimaModifica;
  /// }
  static List<Map<String, dynamic>> teams = new List<Map<String, dynamic>>();

  /// Elenco dei giocatori.
  ///
  /// Template di giocatore inserito:
  /// {
  ///   String key;
  ///   String altezza;
  ///   String capitano;
  ///   String cognome;
  ///   String mancino;
  ///   String nascita;
  ///   String nazionalita;
  ///   String nome;
  ///   String peso;
  ///   String ruolo;
  ///   String squadra: chiave della squadra a cui il giocatore appartiene;
  /// }
  static List<Map<String, dynamic>> players = new List<Map<String, dynamic>>();

  /// Controlla se la squadra con la chiave indicata è presente nella lista.
  static bool hasTeam(String key) {
    for (var team in teams) {
      if (team['key'] == key) return true;
    }
    return false;
  }

  /// Controlla se il giocatore con la chiave indicata è presente nella lista.
  static bool hasPlayer(String key) {
    for (var player in players) {
      if (player['key'] == key) return true;
    }
    return false;
  }

  /// Ritorna un'istanza di una squadra (oppure null) cercandola per chiave.
  static Map<String, dynamic> getTeamByKey(String key) {
    for (var team in teams) {
      if (team['key'] == key) return team;
    }
    return null;
  }

  /// Ritorna un'istanza di un giocatore (oppure null) cercandola per chiave.
  static Map<String, dynamic> getPlayerByKey(String key) {
    for (var player in players) {
      if (player['key'] == key) return player;
    }
    return null;
  }

  /// Ritorna un'istanza di un giocatore (oppure null) cercandola per chiave.
  static List<Map<String, dynamic>> getPlayersOf({String teamKey}) {
    List<Map<String, dynamic>> team = new List<Map<String, dynamic>>();
    for (var player in players) {
      if (player['squadra'] == teamKey) team.add(player);
    }
    return team;
  }

  /// Cambia la chiave di una squadra.
  static void changeTeamKey({String oldKey, String newKey}) {
    for (var team in teams) {
      if (team['key'] == oldKey) {
        team['key'] = newKey;
      }
    }
    store();
  }

  /// Cambia la chiave di un giocatore.
  static void changePlayerKey({String oldKey, String newKey}) {
    for (var player in players) {
      if (player['key'] == oldKey) {
        player['key'] = newKey;
      }
    }
    store();
  }

  /// Aggiunge una squadra alla lista.
  ///
  /// Si occupa di aggiornare sia la lista [teams] che le SharedPreferences.
  static Future<Null> addTeam(Map<String, dynamic> newTeam) async {
    if (hasTeam(newTeam['key']))
      throw new ArgumentError(
          "Tentativo di aggiungere una squadra già presente in lista");
    teams.add(newTeam);
    store();
  }

  /// Aggiunge un giocatore alla lista.
  ///
  /// Si occupa di aggiornare sia la lista [players] che le SharedPreferences.
  static Future<Null> addPlayer(Map<String, dynamic> newPlayer) async {
    if (hasPlayer(newPlayer['key']))
      throw new ArgumentError(
          "Tentativo di aggiungere un giocatore già presente in lista");
    players.add(newPlayer);
    store();
    print("aggiunto giocatore: " + newPlayer.toString());
  }

  /// Aggiorna un giocatore in lista.
  ///
  /// Si occupa di aggiornare sia la lista [players] che le SharedPreferences.
  static Future<Null> updatePlayer(Map<String, dynamic> newPlayer) async {
    if (!hasPlayer(newPlayer['key']))
      throw new ArgumentError(
          "Tentativo di modificare un giocatore non presente in lista");
    Map<String, dynamic> player = getPlayerByKey(newPlayer['key']);
    player['key'] = newPlayer['key'];
    player['altezza'] = newPlayer['altezza'];
    player['capitano'] = newPlayer['capitano'];
    player['cognome'] = newPlayer['cognome'];
    player['mancino'] = newPlayer['mancino'];
    player['nascita'] = newPlayer['nascita'];
    player['nazionalita'] = newPlayer['nazionalita'];
    player['nome'] = newPlayer['nome'];
    player['peso'] = newPlayer['peso'];
    player['ruolo'] = newPlayer['ruolo'];
    player['squadra'] = newPlayer['squadra'];
    store();
    print("aggiornato giocatore: " + newPlayer.toString());
  }

  /// Elimina una squadra dalla lista.
  ///
  /// Si occupa di aggiornare sia la lista [teams] che le SharedPreferences.
  static Future<Null> removeTeam(String key) async {
    teams.remove(getTeamByKey(key));
    store();
  }

  /// Elimina un giocatore dalla lista.
  ///
  /// Si occupa di aggiornare sia la lista [teams] che le SharedPreferences.
  static Future<Null> removePlayer(String key) async {
    players.remove(getPlayerByKey(key));
    store();
  }

  /// Salva le modifiche nelle SharedPrederences.
  static Future<Null> store() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefTeamsKey, JSON.encode(teams));
    prefs.setString(prefPlayersKey, JSON.encode(players));
  }

  /// Legge le SharedPreferences.
  /// Stampa un su console in caso di NoSuchMethodError. Questo si verifica ogni
  /// volta che si tentano di leggere Preferences vuote.
  static Future<Null> readFromFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      teams = JSON.decode(prefs.getString(prefTeamsKey));
      players = JSON.decode(prefs.getString(prefPlayersKey));
    } on NoSuchMethodError {
      print("Errore nella lettura delle sharedPreferences, " +
          "probabilmente non sono ancora state create");
    }
  }
}

// Templates
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
