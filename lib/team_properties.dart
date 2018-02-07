import 'dart:async';

import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'local_database.dart';
import 'player_list.dart';
import 'setnote_widgets.dart';

/// Pagina di gestione di un singolo team.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere il
/// corrispondente [_TeamPropertiesState].
class TeamProperties extends StatefulWidget {
  TeamProperties({this.selectedTeam});
  final Map<String, dynamic> selectedTeam;
  @override
  _TeamPropertiesState createState() =>
      new _TeamPropertiesState(selectedTeam: selectedTeam);
}

/// State di TeamProperties.
///
/// Riceve da costruttore [selectedTeam], ovvero la squadra che andrà a
/// modificare. Questa può essere una squadra vuota in caso di creazione
/// nuova squadra.
/// [_coloreMaglia] è necessario per manipolare sotto forma di oggetto Color
/// l'informazione rappresentata come stringa nel database.
/// [_whiteButtonText] è una variabile ausiliaria che controlla il colore del
/// testo del pulsante di selezione per [_coloreMaglia].
/// [_formKey] è una variabile ausiliaria per riferirsi al form di input.
/// Gli altri campi dati sono una serie di [TextEditingController], uno per
/// ogni campo di input.
class _TeamPropertiesState extends State<TeamProperties> {
  Map<String, dynamic> selectedTeam;
  Color _coloreMaglia;
  bool _whiteButtonText;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _nomeController = new TextEditingController();
  final TextEditingController _allenatoreController =
      new TextEditingController();
  final TextEditingController _assistenteController =
      new TextEditingController();
  final TextEditingController _categoriaController =
      new TextEditingController();
  final TextEditingController _stagioneController = new TextEditingController();

  /// Costruttore di [_PlayerPropertiesState].
  ///
  /// Gestisce l'uso di opportuni valori di default nel form.
  _TeamPropertiesState({this.selectedTeam}) {
    if (selectedTeam['coloreMaglia'] != 'null' &&
        selectedTeam['coloreMaglia'] != null) {
      _coloreMaglia = new Color(
          int.parse(selectedTeam['coloreMaglia'].substring(8, 16), radix: 16));
    }
    if (selectedTeam['nome'] != null)
      _nomeController.text = selectedTeam['nome'];
    if (selectedTeam['allenatore'] != null)
      _allenatoreController.text = selectedTeam['allenatore'];
    if (selectedTeam['assistente'] != null)
      _assistenteController.text = selectedTeam['assistente'];
    if (selectedTeam['categoria'] != null)
      _categoriaController.text = selectedTeam['categoria'];
    if (selectedTeam['stagione'] != null)
      _stagioneController.text = selectedTeam['stagione'];
    checkTextColor(_coloreMaglia);
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
          (selectedTeam['key'] == null ? "Nuova squadra" : "Aggiorna squadra"),
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
              _newInputNomeSquadra(),
              _newPulsanteColoreMaglia(),
            ],
          ),
          new Row(
            children: <Widget>[
              _newInputAllenatore(),
              _newInputAssistente(),
            ],
          ),
          new Row(
            children: <Widget>[
              _newInputCategoria(),
              _newInputStagione(),
            ],
          ),
          _newGestisciFormazione(),
          _newDeleteTeam(),
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
          _newInputNomeSquadra(),
          new Center(
            child: new Padding(
              padding: constant.standard_margin,
              child: _newPulsanteColoreMaglia(),
            ),
          ),
          _newInputAllenatore(),
          _newInputAssistente(),
          _newInputCategoria(),
          _newInputStagione(),
          _newGestisciFormazione(),
        ],
      ),
    );
  }

  /// Gestisce l'aggiornamento dei valori inseriti tramite form.
  void update(BuildContext context) {
    final FormState form = _formKey.currentState;
    form.save();
    selectedTeam['ultimaModifica'] =
        new DateTime.now().millisecondsSinceEpoch.toString();
    // Se ci si trova davanti ad una squadra appena creata è necessario
    // associare una chiave e aggiungerla al database.
    if (selectedTeam['key'] == null) {
      selectedTeam['key'] =
          new DateTime.now().millisecondsSinceEpoch.toString();
      selectedTeam['weight'] = 1;
      Map<String, Map<String, double>> dataSet =
      new Map<String, Map<String, double>>();
      for (String fondamentale in constant.fondamentali) {
        dataSet[fondamentale] = new Map<String, double>();
        for (String esito in constant.esiti) {
          dataSet[fondamentale][esito] = 0.0;
        }
      }
      selectedTeam['dataSet'] = dataSet;
      LocalDB.addTeam(selectedTeam);
    } else {
      LocalDB.store();
    }
    Navigator.of(context).pop();
  }

  /// Calcola [_whiteButtonText] in base al valore passato in input
  /// (tipicamente sarà il colore di maglia).
  void checkTextColor(Color color) {
    if (color == null) {
      _whiteButtonText = false;
    } else {
      if (color.computeLuminance() > 0.179) {
        _whiteButtonText = false;
      } else {
        _whiteButtonText = true;
      }
    }
  }

  /// Genera un nuovo pulsante per la selezione del colore di maglia.
  ///
  /// Gestisce anche la generazione della dialog corrispondente.
  Widget _newPulsanteColoreMaglia() {
    return new RaisedButton(
      color: _coloreMaglia,
      child: new Text(
        "Colore di maglia",
        style: new TextStyle(
            color: (_whiteButtonText ? Colors.white : Colors.black)),
      ),
      onPressed: () => showDialog<Color>(
            context: context,
            child: new SetnoteColorSelector(),
          ).then((Color newColor) {
            _coloreMaglia = newColor;
            selectedTeam['coloreMaglia'] = newColor.toString();
            checkTextColor(newColor);
          }),
    );
  }

  /// Genera un nuovo campo di input per il nome della squadra.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputNomeSquadra() {
    Widget content = new TextFormField(
      controller: _nomeController,
      initialValue: _nomeController.text,
      decoration: const InputDecoration(
        labelText: 'Nome squadra',
        hintText: 'Come si chiama la squadra che stai inserendo? *',
      ),
      onSaved: (String value) {
        selectedTeam['nome'] = value;
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

  /// Genera un nuovo campo di input per il nome dell'allenatore della squadra.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputAllenatore() {
    Widget content = new TextFormField(
      controller: _allenatoreController,
      initialValue: _allenatoreController.text,
      decoration: const InputDecoration(
        labelText: 'Allenatore',
        hintText: 'Come si chiama l\'allenatore? *',
      ),
      onSaved: (String value) {
        selectedTeam['allenatore'] = value;
      },
    );
    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Expanded(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per il nome dell'assistente allenatore.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputAssistente() {
    Widget content = new TextFormField(
      controller: _assistenteController,
      initialValue: _assistenteController.text,
      decoration: const InputDecoration(
        labelText: 'Assistente',
        hintText: 'Come si chiama l\'assistente? *',
      ),
      onSaved: (String value) {
        selectedTeam['assistente'] = value;
      },
    );
    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Expanded(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per la categoria della squadra.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputCategoria() {
    Widget content = new TextFormField(
      controller: _categoriaController,
      initialValue: _categoriaController.text,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        hintText: 'In che categoria gioca? *',
      ),
      onSaved: (String value) {
        selectedTeam['categoria'] = value;
      },
    );
    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Expanded(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo campo di input per la stagione associata alla squadra.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputStagione() {
    Widget content = new TextFormField(
      controller: _stagioneController,
      initialValue: _stagioneController.text,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Stagione',
        hintText: 'AAAA *',
      ),
      onSaved: (String value) {
        selectedTeam['stagione'] = value;
      },
    );
    MediaQueryData media = MediaQuery.of(context);
    if (media.orientation == Orientation.landscape &&
        media.size.width >= 950.00) {
      return new Expanded(
        child: new Padding(padding: constant.lateral_margin, child: content),
      );
    } else {
      return new Padding(
        padding: constant.lateral_margin,
        child: content,
      );
    }
  }

  /// Genera un nuovo pulsante che rimanda al gestore di formazione.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newGestisciFormazione() {
    if (selectedTeam['key'] == null) {
      return new Container(width: 0.0, height: 0.0);
    }
    return new Padding(
      padding: constant.standard_margin,
      child: new Center(
          child: new RaisedButton(
        child: const Text('Gestisci formazione'),
        onPressed: () async {
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new PlayerList(team: selectedTeam)));
        },
      )),
    );
  }

  /// Genera un nuovo pulsante per eliminare la squadra correntemente
  /// selezionata dal database locale.
  Widget _newDeleteTeam() {
    if (selectedTeam['key'] == null) {
      return new Container(width: 0.0, height: 0.0);
    }
    return new Padding(
      padding: constant.standard_margin,
      child: new Center(
        child: new RaisedButton(
          child: const Text('Elimina squadra'),
          onPressed: _deleteTeam,
        ),
      ),
    );
  }

  /// Elimina la squadra correntemente selezionata dal database locale.
  Future<Null> _deleteTeam() async {
    await showDialog(
      context: context,
      child: new AlertDialog(
        title: const Text("Eliminare giocatore?"),
        content: const Text("Questo eliminerà il giocatore selezionato. Non è "
            "possibile annullare l'operazione. Sei sicuro?"),
        actions: <Widget>[
          new FlatButton(
            child: new Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text('SÌ'),
            onPressed: () {
              LocalDB.removeTeam(selectedTeam['key']);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
