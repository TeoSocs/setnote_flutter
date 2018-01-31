import 'package:flutter/material.dart';

import 'drawer.dart';

/// Layout standard dell'applicazione.
///
/// L'aspetto varia in base al form factor del dispositivo.
class SetnoteBaseLayout extends StatelessWidget {
  SetnoteBaseLayout(
      {this.child,
      this.title,
      this.drawer: const MyDrawer(),
      this.floatingActionButton});
  final Widget child;
  final String title;
  final Widget floatingActionButton;
  final Widget drawer;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        MediaQueryData media = MediaQuery.of(context);
        if (media.orientation == Orientation.landscape &&
            media.size.width >= 950.00) {
          return _newTabletLayout();
        } else {
          return _newPhoneLayout();
        }
      },
    );
  }

  /// Layout standard per i tablet.
  Scaffold _newTabletLayout() {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      floatingActionButton: floatingActionButton,
      body: new Row(
        children: <Widget>[
          new Drawer(
            child: drawer,
          ),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// Layout standard per gli smartphone.
  Scaffold _newPhoneLayout() {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      floatingActionButton: floatingActionButton,
      drawer: new Drawer(
        child: drawer,
      ),
      body: child,
    );
  }
}

/// Widget in attesa di una condizione.
///
/// Mostra [child] solo se [condition] è vera, altrimenti mostra un
/// indicatore di caricamento circolare animato.
class LoadingWidget extends StatelessWidget {
  LoadingWidget({this.condition, this.child});
  final bool condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return child;
    } else {
      return new Center(child: new CircularProgressIndicator());
    }
  }
}

/// Selettore di colore.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class SetnoteColorSelector extends StatefulWidget {
  SetnoteColorSelector({this.red: 33.0, this.green: 77.0, this.blue: 130.0});
  final double red, green, blue;

  @override
  _SetnoteColorSelectorState createState() =>
      new _SetnoteColorSelectorState(red: red, green: green, blue: blue);
}

/// State di SetnoteColorSelector.
///
/// Riceve da costruttore tre parametri [red], [green], e [blue] associati ai
/// colori primari. Costruisce una dialog che presenta un rettangolo del
/// colore selezionato e tre slider che permettono di modificarne le
/// componenti RGB. A colore selezionato lo ritorna attraverso Navigator.pop().
class _SetnoteColorSelectorState extends State<SetnoteColorSelector> {
  double red, green, blue;

  _SetnoteColorSelectorState({this.red, this.green, this.blue});

  @override
  Widget build(BuildContext context) {
    BoxDecoration box = new BoxDecoration(
      color: new Color.fromARGB(255, red.round(), green.round(), blue.round()),
    );

    return new AlertDialog(
        contentPadding: new EdgeInsets.all(0.0),
        content: new IntrinsicWidth(
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                new ClipRect(
                    child: new Container(
                        width: 50.0, height: 180.0, decoration: box)),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0)),
                new Slider(
                    value: red,
                    min: 0.0,
                    max: 255.0,
                    activeColor: Colors.red[400],
                    onChanged: (double value) {
                      setState(() {
                        red = value;
                      });
                    }),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                new Slider(
                    value: green,
                    min: 0.0,
                    max: 255.0,
                    activeColor: Colors.green[400],
                    onChanged: (double value) {
                      setState(() {
                        green = value;
                      });
                    }),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                new Slider(
                    value: blue,
                    min: 0.0,
                    max: 255.0,
                    activeColor: Colors.blue[400],
                    onChanged: (double value) {
                      setState(() {
                        blue = value;
                      });
                    }),
              ]),
        ),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Color c = new Color.fromARGB(
                    255, red.round(), green.round(), blue.round());
                Navigator.pop(context, c);
              },
              child: new Text('Select'))
        ]);
  }
}

/// Pulsante associato ad un SetnoteColorSelector.
///
/// È uno StatefulWidget, per una descrizione del suo funzionamento vedere lo
/// State corrispondente.
class SetnoteColorSelectorButton extends StatefulWidget {
  SetnoteColorSelectorButton({this.label});
  final String label;

  @override
  _SetnoteColorSelectorButtonState createState() =>
      new _SetnoteColorSelectorButtonState(label: label);
}

/// State di SetnoteColorSelectorButton.
///
/// Costruisce un pulsante il cui colore di sfondo corrisponde con il colore
/// selezionato. Il colore del testo si adatta in base al colore di sfondo.
class _SetnoteColorSelectorButtonState
    extends State<SetnoteColorSelectorButton> {
  _SetnoteColorSelectorButtonState({this.label});
  String label;
  SetnoteColorSelector selector = new SetnoteColorSelector();
  Color _buttonColor;
  bool _whiteText = false;

  @override
  Widget build(BuildContext context) {
    if (_buttonColor == null) {
      _buttonColor = Theme.of(context).buttonColor;
    }
    return new RaisedButton(
      color: _buttonColor,
      child: new Text(
        label,
        style: new TextStyle(color: (_whiteText ? Colors.white : Colors.black)),
      ),
      onPressed: () {
        showDialog<Color>(
          context: context,
          child: selector,
        )
            .then((Color newColor) => setState(() {
                  _buttonColor = newColor;
                  if (newColor.computeLuminance() > 0.179) {
                    _whiteText = false;
                  } else {
                    _whiteText = true;
                  }
                }));
      },
    );
  }
}
