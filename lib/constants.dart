import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const app_name = "Setnote";

const match_label = "Nuova partita";
const team_label = "Gestione squadra";
const add_team_label = "Aggiungi squadra";
const stats_label = "Statistiche squadra";
const history_label = "Archivio partite";
const settings_label = "Impostazioni";

const formations_label = "Formazioni";

const standard_margin = const EdgeInsets.all(10.0);
const lateral_margin = const EdgeInsets.symmetric(horizontal: 16.0);
const form_page_margin = const EdgeInsets.symmetric(horizontal: 100.0);

final teamDB = FirebaseDatabase.instance.reference().child('squadre');

class TeamInstance {
  TeamInstance({
    this.nomeSquadra,
    this.allenatore,
    this.assistente,
    this.categoria,
    this.stagione,
    this.coloreMaglia,
  });
  String nomeSquadra;
  String allenatore;
  String assistente;
  String categoria;
  String stagione;
  Color coloreMaglia;
  String key;

  void update([
    newNomeSquadra,
    newAllenatore,
    newAssistente,
    newCategoria,
    newStagione,
    newColoreMaglia,
    newKey
  ]) {
    nomeSquadra = newNomeSquadra;
    allenatore = newAllenatore;
    assistente = newAssistente;
    categoria = newCategoria;
    stagione = newStagione;
    coloreMaglia = newColoreMaglia;
    key = newKey;
  }

  void clear() {
    nomeSquadra = null;
    allenatore = null;
    assistente = null;
    categoria = null;
    stagione = null;
    coloreMaglia = null;
    key = null;
  }
}

final TeamInstance selectedTeam = new TeamInstance();