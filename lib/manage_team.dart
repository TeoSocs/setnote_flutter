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
  }
  ManageTeamModel model;
  Color _coloreMaglia;
  bool _whiteButtonText = false;

  @override
  Widget build(BuildContext context) {
    _coloreMaglia = selectedTeam.coloreMaglia;
    if (_coloreMaglia == null) {
      _coloreMaglia = Theme.of(context).buttonColor;
    }
    return new Scaffold(
      appBar: new AppBar(title: new Text(model.title)),
      body: new Center(
          child: new LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            MediaQueryData media = MediaQuery.of(context);
            if (media.orientation == Orientation.landscape && media.size.width >= 950.00) {
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
                    (selectedTeam.key == null
                        ? new SetnoteButton(
                      label: "Aggiungi squadra",
                      onPressed: () => model.submit(context),
                    )
                        : new SetnoteButton(
                      label: "Aggiorna squadra",
                      onPressed: () => model.update(context),
                    )),
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
                    (selectedTeam.key == null
                        ? new SetnoteButton(
                      label: "Aggiungi squadra",
                      onPressed: () => model.submit(context),
                    )
                        : new SetnoteButton(
                      label: "Aggiorna squadra",
                      onPressed: () => model.update(context),
                    )),
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
      setState(() => _coloreMaglia = newColor);
      if (newColor.computeLuminance() > 0.179) {
        _whiteButtonText = false;
      } else {
        _whiteButtonText = true;
      }
    });
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
    return new MyTabletTextFormField(
      initialValue: model.nomeSquadraInitial,
      decoration: const InputDecoration(
        labelText: 'Nome squadra',
        hintText: 'CAME Casier',
      ),
      onSaved: (String value) {
        model.nomeSquadra = value;
      },
    );
  }

  Widget _newInputAllenatore() {
    return new MyTabletTextFormField(
      initialValue: model.allenatoreInitial,
      decoration: const InputDecoration(
        labelText: 'Allenatore',
        hintText: 'G. Povia',
      ),
      onSaved: (String value) {
        model.allenatore = value;
      },
    );
  }

  Widget _newInputAssistente() {
    return new MyTabletTextFormField(
      initialValue: model.assistenteInitial,
      decoration: const InputDecoration(
        labelText: 'Assistente',
        hintText: 'A. Uscolo',
      ),
      onSaved: (String value) {
        model.assistente = value;
      },
    );
  }

  Widget _newInputCategoria() {
    return new MyTabletTextFormField(
      initialValue: model.categoriaInitial,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        hintText: 'Serie C Maschile',
      ),
      onSaved: (String value) {
        model.categoria = value;
      },
    );
  }

  Widget _newInputStagione() {
    return new MyTabletTextFormField(
      initialValue: model.stagioneInitial,
      decoration: const InputDecoration(
        labelText: 'Stagione',
        hintText: '2018',
      ),
      onSaved: (String value) {
        model.stagione = value;
      },
    );
  }

}
