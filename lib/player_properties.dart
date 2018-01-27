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

  final TextEditingController _altezzaController = new TextEditingController();
  final TextEditingController _capitanoController = new TextEditingController();
  final TextEditingController _cognomeController = new TextEditingController();
  final TextEditingController _mancinoController = new TextEditingController();
  final TextEditingController _nascitaController = new TextEditingController();
  final TextEditingController _nazionalitaController =
      new TextEditingController();
  final TextEditingController _nomeController = new TextEditingController();
  final TextEditingController _numeroController = new TextEditingController();
  final TextEditingController _pesoController = new TextEditingController();
  final TextEditingController _ruoloController = new TextEditingController();
  final TextEditingController _squadraController = new TextEditingController();

  /// Costruttore di [_PlayerPropertiesState].
  ///
  /// Gestisce l'uso di opportuni valori di default nel form.
  _PlayerPropertiesState({this.selectedPlayer}) {
    if (selectedPlayer['altezza'] != null)
      _altezzaController.text = selectedPlayer['altezza'];
    if (selectedPlayer['capitano'] != null)
      _capitanoController.text = selectedPlayer['capitano'];
    if (selectedPlayer['cognome'] != null)
      _cognomeController.text = selectedPlayer['cognome'];
    if (selectedPlayer['mancino'] != null)
      _mancinoController.text = selectedPlayer['mancino'];
    if (selectedPlayer['nascita'] != null)
      _nascitaController.text = selectedPlayer['nascita'];
    if (selectedPlayer['nazionalita'] != null)
      _nazionalitaController.text = selectedPlayer['nazionalita'];
    if (selectedPlayer['nome'] != null)
      _nomeController.text = selectedPlayer['nome'];
    if (selectedPlayer['numeroMaglia'] != null)
      _numeroController.text = selectedPlayer['numeroMaglia'];
    if (selectedPlayer['peso'] != null)
      _pesoController.text = selectedPlayer['peso'];
    if (selectedPlayer['ruolo'] != null)
      _ruoloController.text = selectedPlayer['ruolo'];
    if (selectedPlayer['squadra'] != null)
      _squadraController.text = selectedPlayer['squadra'];
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
      title: (selectedPlayer['key'] == null
          ? "Nuovo giocatore"
          : "Aggiorna "
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
          new Row(
            children: <Widget>[
              _newInputNome(),
              _newInputCognome(),
              _newInputRuolo(),
              _newInputNumero(),
            ],
          ),
          new Row(
            children: <Widget>[
              _newInputNascita(),
              _newInputNazionalita(),
            ],
          ),
          new Row(
            children: <Widget>[
              _newInputMancino(),
              _newInputCapitano(),
              _newInputAltezza(),
              _newInputPeso(),
            ],
          ),
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
          _newInputNome(),
          _newInputCognome(),
          _newInputRuolo(),
          _newInputNumero(),
          _newInputNascita(),
          _newInputNazionalita(),
          _newInputMancino(),
          _newInputCapitano(),
          _newInputAltezza(),
          _newInputPeso(),
          _newDeletePlayer(),
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

  /// Genera un nuovo campo di input per il nome del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputNome() {
    Widget content = new TextFormField(
      controller: _nomeController,
      initialValue: _nomeController.text,
      decoration: const InputDecoration(
        labelText: 'Nome',
      ),
      onSaved: (String value) {
        selectedPlayer['nome'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per il cognome del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputCognome() {
    Widget content = new TextFormField(
      controller: _cognomeController,
      initialValue: _cognomeController.text,
      decoration: const InputDecoration(
        labelText: 'Cognome',
      ),
      onSaved: (String value) {
        selectedPlayer['cognome'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per il ruolo del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputRuolo() {
    Widget content = new TextFormField(
      controller: _ruoloController,
      initialValue: _ruoloController.text,
      decoration: const InputDecoration(
        labelText: 'Ruolo',
      ),
      onSaved: (String value) {
        selectedPlayer['ruolo'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per il ruolo del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputNumero() {
    Widget content = new TextFormField(
      controller: _numeroController,
      initialValue: _numeroController.text,
      decoration: const InputDecoration(
        labelText: 'Numero Maglia',
      ),
      onSaved: (String value) {
        selectedPlayer['numeroMaglia'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per la data di nascita del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputNascita() {
    Widget content = new TextFormField(
      controller: _nascitaController,
      initialValue: _nascitaController.text,
      decoration: const InputDecoration(
        labelText: 'Data di nascita',
      ),
      onSaved: (String value) {
        selectedPlayer['nascita'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per la nazionalita del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputNazionalita() {
    Widget content = new TextFormField(
      controller: _nazionalitaController,
      initialValue: _nazionalitaController.text,
      decoration: const InputDecoration(
        labelText: 'Nazionalità',
      ),
      onSaved: (String value) {
        selectedPlayer['nazionalita'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per indicare se il giocatore è mancino.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputMancino() {
    Widget content = new TextFormField(
      controller: _mancinoController,
      initialValue: _mancinoController.text,
      decoration: const InputDecoration(
        labelText: 'Mancino',
      ),
      onSaved: (String value) {
        selectedPlayer['mancino'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per indicare se il giocatore è il capitano.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputCapitano() {
    Widget content = new TextFormField(
      controller: _capitanoController,
      initialValue: _capitanoController.text,
      decoration: const InputDecoration(
        labelText: 'Capitano',
      ),
      onSaved: (String value) {
        selectedPlayer['capitano'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per l'altezza del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputAltezza() {
    Widget content = new TextFormField(
      controller: _altezzaController,
      initialValue: _altezzaController.text,
      decoration: const InputDecoration(
        labelText: 'Altezza',
      ),
      onSaved: (String value) {
        selectedPlayer['altezza'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per il peso del giocatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputPeso() {
    Widget content = new TextFormField(
      controller: _pesoController,
      initialValue: _pesoController.text,
      decoration: const InputDecoration(
        labelText: 'Peso',
      ),
      onSaved: (String value) {
        selectedPlayer['peso'] = value;
      },
    );

    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Flexible(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
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