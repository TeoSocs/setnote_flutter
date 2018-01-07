import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';
import 'setnote_widgets.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({this.title});
  final String title;
  @override
  _MatchPageState createState() => new _MatchPageState(title: title);
}

class _MatchPageState extends State<MatchPage> {
  _MatchPageState({this.title});

  final String title;
  bool _enabled = false;
  int _act = 1;

  int radioValue = 0;

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(constant.app_name + " - " + title)),
        drawer: new Drawer(
          child: new MyDrawer(),
        ),
        body: new Center(
            child: new ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420.0),
          child: new Form(
              child: new ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Squadra A',
                          labelText: 'Squadra A *',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    new Flexible(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Squadra B',
                          labelText: 'Squadra B *',
                        ),
                      ),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Campionato',
                          labelText: 'Campionato *',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'How do you log in?',
                          labelText: 'New Password *',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'How do you log in?',
                          labelText: 'Re-type Password *',
                        ),
                      ),
                    ),
                  ],
                ),
                new Column(children: <Widget>[
                  new Row(children: <Widget>[
                    new Radio<int>(
                        value: 0,
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged),
                    new Text(
                      'Maschile',
                    ),
                  ]),
                  new Row(children: <Widget>[
                    new Radio<int>(
                        value: 1,
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged),
                    new Text(
                      'Femminile',
                    ),
                  ]),

                ]),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: constant.lateral_margin,
                        child: new TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'How do you log in?',
                            labelText: 'New Password *',
                          ),
                        ),
                      ),
                    ),

                    new Expanded(
                      child: new Padding(
                        padding: constant.lateral_margin,
                        child: new TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'How do you log in?',
                            labelText: 'New Password *',
                          ),
                        ),
                      ),
                    ),

                    new Switch(
                      value: _enabled,
                      onChanged: (bool value) {
                        setState(() {
                          _enabled = value;
                        });
                      },
                    ),
                  ],
                ),
                new ListTile(
                    leading: const Icon(Icons.flight_land),
                    title: (_act == 1
                        ? const Text('Trix\'s airplane')
                        : const Text('Culo')),
                    subtitle: _act != 2
                        ? const Text('The airplane is only in Act II.')
                        : null,
                    onTap: () {
                      setState(() => (_act == 1 ? _act = 2 : _act = 1));
                    }),
                new SetnoteButton(
                    label: constant.formations_label,
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/formations"))
              ])),
        )));
  }
}
