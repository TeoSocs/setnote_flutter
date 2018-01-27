import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'local_database.dart';
import 'setnote_widgets.dart';

/// Pagina di gestione di un singolo giocatore.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere il
/// corrispondente [_PlayerPropertiesState].
class PlayerProperties extends StatefulWidget {
  PlayerProperties({this.selectedPlayer});
  final Map<String, dynamic> selectedPlayer;
  @override
  _PlayerPropertiesState createState() =>
      new _PlayerPropertiesState(selectedPlayer: selectedPlayer);
}

/// State di PlayerProperties.
///
/// Riceve da costruttore [selectedPlayer], ovvero il giocatore che andrà a
/// modificare. Questo può essere un giocatore vuota in caso di creazione
/// nuovo giocatore.
/// [_formKey] è una variabile ausiliaria per riferirsi al form di input.
/// Gli altri campi dati sono una serie di [TextEditingController], uno per
/// ogni campo di input.
class _PlayerPropertiesState extends State<PlayerProperties> {
  Map<String, dynamic> selectedPlayer;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _nomeGiocatoreController =
  new TextEditingController();

  /// Costruttore di [_PlayerPropertiesState].
  ///
  /// Gestisce l'uso di opportuni valori di default nel caso di campi nulli
  /// nel giocatore passato in input. Questo per evitare problemi nel
  /// recuperare i valori iniziali da parte del form.
  _PlayerPropertiesState({this.selectedPlayer}) {
    if (selectedPlayer['altezza'] == null) selectedPlayer['altezza'] = '';
    if (selectedPlayer['capitano'] == null) selectedPlayer['capitano'] = '';
    if (selectedPlayer['cognome'] == null) selectedPlayer['cognome'] = '';
    if (selectedPlayer['mancino'] == null) selectedPlayer['mancino'] = '';
    if (selectedPlayer['nascita'] == null) selectedPlayer['nascita'] = '';
    if (selectedPlayer['nazionalita'] == null) selectedPlayer['nazionalita'] =
    '';
    if (selectedPlayer['nome'] == null) selectedPlayer['nome'] = '';
    if (selectedPlayer['peso'] == null) selectedPlayer['peso'] = '';
    if (selectedPlayer['ruolo'] == null) selectedPlayer['ruolo'] = '';
    if (selectedPlayer['squadra'] == null) selectedPlayer['squadra'] = '';
  }


  /// Costruisce la pagina.
  ///
  /// Controlla se il dispositivo è identificabile come tablet o smartphone e
  /// carica il layout di pagina più appropriato.
  @override
  Widget build(BuildContext context) {
    return new SetnoteBaseLayout(
      floatingActionButton: new FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () => update(context),
      ),
      title:
      (selectedPlayer['key'] == null ? "Nuovo giocatore" : "Aggiorna "
          "giocatore"),
      child: new Center(
        child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              MediaQueryData media = MediaQuery.of(context);
              if (media.orientation == Orientation.landscape &&
                  media.size.width >= 950.00) {
                return _newTabletForm();
              } else {
                return _newPhoneForm();
              }
            }),
      ),
    );
  }

  /// Costruisce il form in formato tablet.
  Form _newTabletForm() {
    return new Form(
      key: _formKey,
      autovalidate: true,
      child: new ListView(
        padding: constant.standard_margin,
        children: <Widget>[
          // TODO: disegna il form
          _newDeletePlayer(),
        ],
      ),
    );
  }

  /// Costruisce il form in formato smartphone.
  Form _newPhoneForm() {
    return new Form(
      key: _formKey,
      autovalidate: true,
      child: new ListView(
        padding: constant.standard_margin,
        children: <Widget>[
          // TODO: disegna il form
        ],
      ),
    );
  }

  /// Gestisce l'aggiornamento dei valori inseriti tramite form.
  void update(BuildContext context) {
    final FormState form = _formKey.currentState;
    form.save();
    // Se ci si trova davanti ad un giocatore appena creato è necessario
    // associare una chiave e aggiungerlo al database.
    if (selectedPlayer['key'] == null) {
      selectedPlayer['key'] =
          new DateTime.now().millisecondsSinceEpoch.toString();
      LocalDB.addPlayer(selectedPlayer);
    } else {
      LocalDB.store();
    }
    Navigator.of(context).pop();
  }

  /// Genera un nuovo pulsante per eliminare il giocatore correntemente
  /// selezionato dal database locale.
  Widget _newDeletePlayer() {
    // Se nessun giocatore è selezionato (sto creando un nuovo giocatore) non
    // mostrare nulla.
    if (selectedPlayer['key'] == null) {
      return new Container(width: 0.0, height: 0.0);
    }
    return new Padding(
      padding: constant.standard_margin,
      child: new Center(
        child: new RaisedButton(
          child: const Text('Elimina giocatore'),
          onPressed: _deleteTeam,
        ),
      ),
    );
  }

  /// Elimina il giocatore correntemente selezionato dal database locale.
  void _deleteTeam() {
    LocalDB.removeTeam(selectedPlayer['key']);
    Navigator.of(context).pop();
  }
}