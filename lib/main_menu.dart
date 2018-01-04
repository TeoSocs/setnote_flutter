import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Setnote")
        ),
        body: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            new MenuButton(label: "Nuova partita", address: "/match",),
            new MenuButton(label: "Gestione squadra", address: "/team"),
            new MenuButton(label: "Statistiche squadra", address: "/stats"),
            new MenuButton(label: "Archivio partite", address: "/history"),
            new MenuButton(label: "Impostazioni", address: "/settings"),
          ],
        )
    );
  }
}


class MenuButton extends StatelessWidget {
  MenuButton({this.label, this.address});
  final String label;
  final String address;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new RaisedButton(
        child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Text(label)
        ),
        onPressed: () => Navigator.of(context).pushNamed(address),
      ),
    );
  }
}