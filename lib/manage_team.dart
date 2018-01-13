import 'package:flutter/material.dart';
import 'package:setnote_flutter/manage_team_model.dart';
import 'package:setnote_flutter/setnote_widgets.dart';

import 'constants.dart' as constant;

class ManageTeam extends StatefulWidget {
  @override
  ManageTeamState createState() => new ManageTeamState();
}

class ManageTeamState extends State<ManageTeam> {
  ManageTeamState() {
    model = new ManageTeamModel();
    checkTextColor(selectedTeam.coloreMaglia);
  }
  ManageTeamModel model;
  Color _coloreMaglia = selectedTeam.coloreMaglia;
  bool _whiteButtonText;


  @override
  Widget build(BuildContext context) {
    if (_coloreMaglia == null) {
      _coloreMaglia = Theme.of(context).buttonColor;
    }
    return new Scaffold(
      appBar: new AppBar(title: new Text(model.title)),
      floatingActionButton: new FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: (selectedTeam.key == null
            ? () => model.submit(context)
            : () => model.update(context)),
      ),
      body: new Center(
        child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          MediaQueryData media = MediaQuery.of(context);
          if (media.orientation == Orientation.landscape &&
              media.size.width >= 950.00) {
            return new Form(
              key: model.formKey,
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
                ],
              ),
            );
          } else {
            return new Form(
              key: model.formKey,
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
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  void _selectColor() {
    showDialog<Color>(
      context: context,
      child: new SetnoteColorSelector(),
    ).then((Color newColor) {
      _coloreMaglia = newColor;
      model.coloreMaglia = newColor;
      checkTextColor(newColor);
    });
  }

  void checkTextColor(color) {
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

  Widget _newPulsanteColoreMaglia() {
    return new RaisedButton(
      color: _coloreMaglia,
      child: new Text(
        "Colore di maglia",
        style: new TextStyle(
            color: (_whiteButtonText ? Colors.white : Colors.black)),
      ),
      onPressed: _selectColor,
    );
  }

  Widget _newInputNomeSquadra() {
    Widget content = new TextFormField(
      initialValue: model.nomeSquadraInitial,
      decoration: const InputDecoration(
        labelText: 'Nome squadra',
        hintText: 'CAME Casier',
      ),
      onSaved: (String value) {
        model.nomeSquadra = value;
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

  Widget _newInputAllenatore() {
    Widget content = new TextFormField(
      initialValue: model.allenatoreInitial,
      decoration: const InputDecoration(
        labelText: 'Allenatore',
        hintText: 'G. Povia',
      ),
      onSaved: (String value) {
        model.allenatore = value;
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

  Widget _newInputAssistente() {
    Widget content = new TextFormField(
      initialValue: model.assistenteInitial,
      decoration: const InputDecoration(
        labelText: 'Assistente',
        hintText: 'A. Uscolo',
      ),
      onSaved: (String value) {
        model.assistente = value;
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

  Widget _newInputCategoria() {
    Widget content = new TextFormField(
      initialValue: model.categoriaInitial,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        hintText: 'Serie C Maschile',
      ),
      onSaved: (String value) {
        model.categoria = value;
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

  Widget _newInputStagione() {
    Widget content = new TextFormField(
      initialValue: model.stagioneInitial,
      decoration: const InputDecoration(
        labelText: 'Stagione',
        hintText: '2018',
      ),
      onSaved: (String value) {
        model.stagione = value;
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
}
