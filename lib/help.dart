import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Manuale'),
      content: new Text('Qui va scritto il manuale anche se quasi quasi '
          'scriverei da qualche altra parte del testo formattato decentemente'
          ' e poi lo includerei qui con qualche magheggio'),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Chiudi'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}