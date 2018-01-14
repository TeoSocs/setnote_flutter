import 'package:flutter/material.dart';

import 'constants.dart' as constant;
import 'drawer.dart';

class SetnoteButton extends StatelessWidget {
  SetnoteButton({this.label, this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: constant.standard_margin,
      child: new RaisedButton(
        child: new Text(label),
        onPressed: onPressed,
      ),
    );
  }
}

class SetnoteBaseLayout extends StatelessWidget {
  SetnoteBaseLayout({this.child, this.title, this.drawer, this.floatingActionButton}) {
    if (drawer == null) {
      drawer = new MyDrawer();
    }
  }
  final Widget child;
  final String title;
  Widget drawer;
  Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        MediaQueryData media = MediaQuery.of(context);
        if (media.orientation == Orientation.landscape &&
            media.size.width >= 950.00) {
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
                    padding: const EdgeInsets.only(left:3.0),
                    child: child,
                  ),
                ),
              ],
            ),
          );
        } else {
          return new Scaffold(
            appBar: new AppBar(title: new Text(title)),
            floatingActionButton: floatingActionButton,
            drawer: new Drawer(
              child: new MyDrawer(),
            ),
            body: child,
          );
        }
      },
    );
  }
}

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

class SetnoteColorSelector extends StatefulWidget {
  SetnoteColorSelector({this.red: 33.0, this.green: 77.0, this.blue: 130.0});
  final double red, green, blue;

  @override
  SetnoteColorSelectorState createState() =>
      new SetnoteColorSelectorState(red: red, green: green, blue: blue);
}

class SetnoteColorSelectorState extends State<SetnoteColorSelector> {
  SetnoteColorSelectorState({this.red, this.green, this.blue});

  double red, green, blue;

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

class SetnoteColorSelectorButton extends StatefulWidget {
  SetnoteColorSelectorButton({this.label});
  final String label;

  @override
  SetnoteColorSelectorButtonState createState() =>
      new SetnoteColorSelectorButtonState(label: label);
}

class SetnoteColorSelectorButtonState
    extends State<SetnoteColorSelectorButton> {
  SetnoteColorSelectorButtonState({this.label});
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
