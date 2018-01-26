import 'package:flutter/material.dart';
import 'package:setnote_flutter/local_team_list.dart';
import 'package:setnote_flutter/roster_manager.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;

class ManageTeam extends StatefulWidget {
  ManageTeam({this.selectedTeam});
  final Map<String, dynamic> selectedTeam;
  @override
  _ManageTeamState createState() =>
      new _ManageTeamState(selectedTeam: selectedTeam);
}

/// Pagina di gestione di un singolo team.
///
/// Riceve da costruttore [selectedTeam], ovvero la squadra che andrà a
/// modificare. Questa può essere una squadra vuota in caso di creazione
/// nuova squadra.
/// [_coloreMaglia] è necessario per manipolare sotto forma di oggetto Color
/// l'informazione rappresentata come stringa nel database.
/// [_whiteButtonText] è una variabile ausiliaria che controlla il colore del
/// testo del pulsante di selezione per [_coloreMaglia].
/// [_formKey] è una variabile ausiliaria per riferirsi al form di input.
class _ManageTeamState extends State<ManageTeam> {
  Map<String, dynamic> selectedTeam;
  Color _coloreMaglia;
  bool _whiteButtonText;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  /// Costruttore di _ManageTeamState.
  ///
  /// Gestisce l'uso di opportuni valori di default nel caso di campi nulli
  /// nella squadra passata in input. Questo per evitare problemi nel
  /// recuperare i valori iniziali da parte del form.
  _ManageTeamState({this.selectedTeam}) {
    if (selectedTeam['colore_maglia'] != 'null' &&
        selectedTeam['colore_maglia'] != null) {
      _coloreMaglia = new Color(
          int.parse(selectedTeam['colore_maglia'].substring(8, 16), radix: 16));
    }
    if (selectedTeam['nome'] == null) selectedTeam['nome'] = '';
    if (selectedTeam['allenatore'] == null) selectedTeam['allenatore'] = '';
    if (selectedTeam['assistente'] == null) selectedTeam['assistente'] = '';
    if (selectedTeam['categoria'] == null) selectedTeam['categoria'] = '';
    if (selectedTeam['stagione'] == null) selectedTeam['stagione'] = '';
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
    selectedTeam['ultima_modifica'] =
        new DateTime.now().millisecondsSinceEpoch.toString();
    // Se ci si trova davanti ad una squadra appena creata è necessario
    // associare una chiave e aggiungerla al database.
    if (selectedTeam['key'] == null) {
      selectedTeam['key'] =
          new DateTime.now().millisecondsSinceEpoch.toString();
      LocalDB.add(selectedTeam);
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
            selectedTeam['colore_maglia'] = newColor.toString();
            checkTextColor(newColor);
          }),
    );
  }

  /// Genera un nuovo campo di input per il nome della squadra.
  ///
  /// L'aspetto effettivo dipenderà dal form factor del dispositivo.
  Widget _newInputNomeSquadra() {
    Widget content = new TextFormField(
      initialValue: selectedTeam['nome'],
      decoration: const InputDecoration(
        labelText: 'Nome squadra',
        hintText: 'CAME Casier',
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
      initialValue: selectedTeam['allenatore'],
      decoration: const InputDecoration(
        labelText: 'Allenatore',
        hintText: 'G. Povia',
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
      initialValue: selectedTeam['assistente'],
      decoration: const InputDecoration(
        labelText: 'Assistente',
        hintText: 'A. Uscolo',
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
      initialValue: selectedTeam['categoria'],
      decoration: const InputDecoration(
        labelText: 'Categoria',
        hintText: 'Serie C Maschile',
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
      initialValue: selectedTeam['stagione'],
      decoration: const InputDecoration(
        labelText: 'Stagione',
        hintText: '2018',
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
      return const Text("");
    }
    return new Padding(
      padding: constant.standard_margin,
      child: new Center(
          child: new RaisedButton(
        child: const Text('Gestisci formazione'),
        onPressed: () async {
          await Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) =>
                  new RosterManager(team: selectedTeam)));
        },
      )),
    );
  }
}
