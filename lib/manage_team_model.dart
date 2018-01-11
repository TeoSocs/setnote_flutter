import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

class ManageTeamModel {
  String title = (selectedTeam.nomeSquadra == null ? "Aggiungi squadra" : selectedTeam.nomeSquadra);
  String nomeSquadra;
  String nomeSquadraInitial = (selectedTeam.nomeSquadra != null ? selectedTeam.nomeSquadra : '');
  String allenatore;
  String allenatoreInitial = (selectedTeam.allenatore != null ? selectedTeam.allenatore : '');
  String assistente;
  String assistenteInitial = (selectedTeam.assistente != null ? selectedTeam.assistente : '');
  String categoria;
  String categoriaInitial = (selectedTeam.categoria != null ? selectedTeam.categoria : '');
  String stagione;
  String stagioneInitial = (selectedTeam.stagione != null ? selectedTeam.stagione : '');
  Color coloreMaglia;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  void submit(BuildContext context) {
    final FormState form = formKey.currentState;
    form.save();
    constant.teamDB.push().set({
      'nome': nomeSquadra,
      'allenatore': allenatore,
      'assistente': assistente,
      'stagione': stagione,
      'categoria': categoria,
      'colore_maglia': coloreMaglia.toString(),
    });
    analytics.logEvent(name: 'aggiunta_squadra');
    Navigator.of(context).pop();
  }

  void update(BuildContext context) {
    final FormState form = formKey.currentState;
    form.save();
    constant.teamDB.child(selectedTeam.key).set({
      'nome': nomeSquadra,
      'allenatore': allenatore,
      'assistente': assistente,
      'stagione': stagione,
      'categoria': categoria,
      'colore_maglia': coloreMaglia.toString(),
    });
    analytics.logEvent(name: 'modificata_squadra');
    Navigator.of(context).pop();
  }
}

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