import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'google_auth.dart';

class ManageTeamModel {
  ManageTeamModel({this.selectedTeam});
  TeamInstance selectedTeam;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  void submit(BuildContext context) {
    final FormState form = formKey.currentState;
    form.save();
    constant.teamDB.push().set({
      'nome': selectedTeam.nomeSquadra,
      'allenatore': selectedTeam.allenatore,
      'assistente': selectedTeam.assistente,
      'stagione': selectedTeam.stagione,
      'categoria': selectedTeam.categoria,
      'colore_maglia': selectedTeam.coloreMaglia.toString(),
    });
    analytics.logEvent(name: 'aggiunta_squadra');
    Navigator.of(context).pop();
  }

  void update(BuildContext context) {
    final FormState form = formKey.currentState;
    form.save();
    constant.teamDB.child(selectedTeam.key).set({
      'nome': selectedTeam.nomeSquadra,
      'allenatore': selectedTeam.allenatore,
      'assistente': selectedTeam.assistente,
      'stagione': selectedTeam.stagione,
      'categoria': selectedTeam.categoria,
      'colore_maglia': selectedTeam.coloreMaglia.toString(),
    });
    analytics.logEvent(name: 'modificata_squadra');
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/team');
  }
}

class TeamInstance {
  TeamInstance({
    this.nomeSquadra: '',
    this.allenatore: '',
    this.assistente: '',
    this.categoria: '',
    this.stagione: '',
    this.coloreMaglia,
  }) {
    if (coloreMaglia == null) {
      coloreMaglia = Colors.blue[400];
    }
  }
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
