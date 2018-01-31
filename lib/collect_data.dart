import 'package:flutter/material.dart';
import 'dart:async';

import 'setnote_widgets.dart';

/// Permette di raccogliere dati sulla partita in corso.abstract
/// 
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class CollectData extends StatefulWidget {
  @override
  State createState() => new _CollectDataState();
}

class _CollectDataState extends State<CollectData> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _requestPop,
      child: new SetnoteBaseLayout(
        title: 'Raccolta Dati',
        child: new Text('Pagina di raccolta dati'),
      )
    );
  }

  Future<bool> _requestPop() async {
    bool _areYouSure = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        title: new Text('Vuoi uscire?'),
        content: new Text('Uscendo ora, i dati saranno salvati e non potrai più modificarli. Sei sicuro?'),
        actions: <Widget>[
          new FlatButton(
            child: new Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          new FlatButton(
            child: new Text('SÌ'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
    if (_areYouSure) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    return new Future.value(false);
  }
}