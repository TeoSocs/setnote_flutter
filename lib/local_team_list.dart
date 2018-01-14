class LocalDB {
  static final teams = new List<TeamInstance>();

  static bool has(String key) {
    for (var team in teams) {
      if (team.key == key) return true;
    }
    return false;
  }

  static TeamInstance getByKey(String key) {
    for (var team in teams) {
      if (team.key == key) return team;
    }
    return null;
  }
}

class TeamInstance {
  String nomeSquadra = '';
  String allenatore = '';
  String assistente = '';
  String categoria = '';
  String stagione = '';
  String coloreMaglia = '';
  String key = '';
  String ultimaModifica;
  List<PlayerInstance> giocatori;
}

class PlayerInstance {
  String key = '';
  String altezza = '';
  String capitano = '';
  String cognome = '';
  String mancino = '';
  String nascita = '';
  String nazionalita = '';
  String nome = '';
  String peso = '';
  String ruolo = '';
}

class PlayerData {
  List<FundamentalData> battute;
  List<FundamentalData> ricezioni;
  List<FundamentalData> attacchi;

}

class FundamentalData {
  int doppiopiu;
  int piu;
  int meno;
  int doppiomeno;
}