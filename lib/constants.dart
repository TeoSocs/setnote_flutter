import 'package:flutter/material.dart';

const app_name = "Setnote";

const match_label = "Nuova partita";
const team_label = "Gestione squadra";
const add_team_label = "Aggiungi squadra";
const stats_label = "Statistiche squadra";
const history_label = "Archivio partite";
const settings_label = "Impostazioni";

const formations_label = "Formazioni";

const standard_margin = const EdgeInsets.all(8.0);
const lateral_margin = const EdgeInsets.symmetric(horizontal: 16.0);
const form_page_margin = const EdgeInsets.symmetric(horizontal: 100.0);

final fondamentali = ['Battuta', 'Ricezione', 'Attacco', 'Difesa'];

enum esiti {errato, scarso, buono, ottimo}